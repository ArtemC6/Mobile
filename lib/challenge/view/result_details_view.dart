import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/challenge/widgets/annotation/annotations_with_stats.dart';
import 'package:voccent/challenge/widgets/charts/emotion_chart.dart';
import 'package:voccent/challenge/widgets/charts/energy_chart.dart';
import 'package:voccent/challenge/widgets/charts/pitch_chart.dart';
import 'package:voccent/challenge/widgets/charts/pronunciation_chart.dart';
import 'package:voccent/challenge/widgets/stats_view.dart';
import 'package:voccent/generated/l10n.dart';

class ResultDetails extends StatelessWidget {
  const ResultDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget content;
    final state = context.read<ChallengeCubit>().state;
    final mTheme = Theme.of(context).colorScheme;

    if (MediaQuery.of(context).size.width > 600) {
      content = Row(
        children: [
          Expanded(
            child: ListView(
              children: const [
                EmotionChart(),
                PronunciationChart(),
                EnergyChart(),
                PitchChart(),
                SizedBox(height: 100),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const StatsView(),
                if (state.audiosample?.annotations?.isNotEmpty ?? false)
                  const AnnotationsWithStats(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      );
    } else {
      content = ListView(
        children: [
          const StatsView(),
          const EmotionChart(),
          const PronunciationChart(),
          const EnergyChart(),
          const PitchChart(),
          if (state.audiosample?.annotations?.isNotEmpty ?? false)
            const AnnotationsWithStats(),
          const SizedBox(height: 100),
        ],
      );
    }

    return Scaffold(
      backgroundColor: mTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: mTheme.onBackground,
          ),
        ),
        centerTitle: true,
        title: FxText.titleMedium(
          S.current.contentChallenge.toUpperCase(),
          fontWeight: 900,
          textScaleFactor: 1.2257,
          color: mTheme.primary,
        ),
      ),
      body: Stack(children: [SafeArea(child: content)]),
    );
  }
}
