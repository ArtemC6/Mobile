import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/themes/app_theme.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:intl/intl.dart';
import 'package:voccent/completed_plan/cubit/completed_plan_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/guide/view/categories_translate.dart';
import 'package:voccent/widgets/loading_effect.dart';
import 'package:voccent/widgets/radius_score_widget.dart';

class SinglePlanScreen extends StatelessWidget {
  const SinglePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    @override
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: mTheme.onBackground,
          ),
        ),
      ),
      body: BlocBuilder<CompletedPlanCubit, CompletedPlanState>(
        builder: (context, state) {
          if (state.finishedPlan == null || state.finishedPlan!.pass == null) {
            return LoadingEffect.getComplitedPlanLoading(
              context,
              Theme.of(context),
            );
          }

          final pass = state.finishedPlan!.pass!;
          final startAt = DateFormat().format(pass.startAt!);
          final endAt = DateFormat().format(pass.endAt!);
          final elementsCount = state.finishedPlan!.elements?.length;
          final score = double.tryParse(pass.percent.toString()) ?? 0.0;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FxContainer(
                color: isDarkTheme
                    ? FxAppTheme.theme.cardTheme.color
                    : mTheme.onPrimary.withOpacity(0.75),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          boxShadow: [
                            BoxShadow(
                              color: mTheme.onPrimary.withOpacity(0.20),
                              blurRadius: 24,
                              spreadRadius: 24,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: RadiusScoreWidget(
                            percent: score / 100,
                            fillColor: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                mTheme.primary,
                                mTheme.secondary,
                              ],
                            ),
                            lineColor: mTheme.primary,
                            freeColor: mTheme.onPrimary,
                            lineWidth: 3.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _NumberCounter(
                                  currentNumber: double.parse(
                                    score.toStringAsFixed(0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 6),
                      child: TableInfoWidget(
                        labels: [
                          S.current.planPlanName,
                          S.current.planPlanDescription,
                          S.current.planCampusName,
                          S.current.planElementCount,
                          S.current.genericStarted,
                          S.current.genericCompleted,
                        ],
                        values: [
                          pass.planName ?? '',
                          pass.planDescription ?? '',
                          pass.campusName ?? '',
                          '$elementsCount',
                          startAt,
                          endAt,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TableInfoWidget extends StatelessWidget {
  const TableInfoWidget({
    required this.labels,
    required this.values,
    super.key,
  });
  final List<String> labels;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return FxContainer(
      color: Colors.transparent,
      child: Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(2),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              for (int i = 0; i < labels.length; i++)
                if (values[i] != '')
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: FxText.titleMedium(
                          labels[i].toCapitalized(),
                          color: mTheme.onSurface.withOpacity(1),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 10),
                        child: FxText.titleMedium(
                          values[i],
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberCounter extends StatefulWidget {
  const _NumberCounter({
    required this.currentNumber,
  });

  final double currentNumber;

  @override
  _NumberCounterState createState() => _NumberCounterState();
}

class _NumberCounterState extends State<_NumberCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentNumber = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.currentNumber,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          _currentNumber = _animation.value.toInt();
        });
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return FxText.displayLarge(
      '$_currentNumber%',
      color: mTheme.onPrimary,
    );
  }
}
