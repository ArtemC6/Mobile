import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/playlist/cubit/models/fingerprint/frame.dart';
import 'package:voccent/subscription/cubit/models/current_subscription/value.dart';
import 'package:voccent/subscription/cubit/subscription_cubit.dart';
import 'package:voccent/subscription/widgets/pay_wall.dart';

class EnergyChart extends StatelessWidget {
  const EnergyChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cap = context
        .read<SubscriptionCubit>()
        .capabilityValue(
          '00000000-0000-0000-0000-00000000000b',
          context.read<HomeCubit>().state.user.worklang,
        )
        .string;

    final paid = cap == null || cap == Value.yes;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(6),
      width: double.infinity,
      child: Column(
        children: [
          FxText.bodyLarge(
            S.current.genericEnergy,
            fontWeight: 600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(1),
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: paid ? 120 : 400,
            child: BlocBuilder<ChallengeCubit, ChallengeState>(
              builder: (context, state) {
                final annotationAvgEnergy = state.annotationAvgEnergy();
                const padding = 25;

                return PayWall(
                  capabilityId: '00000000-0000-0000-0000-00000000000b',
                  child: SfCartesianChart(
                    primaryXAxis: const NumericAxis(
                      minimum: 0,
                      maximum: 2.5,
                      interval: 1,
                    ),
                    primaryYAxis: const NumericAxis(
                      minimum: 0,
                      maximum: 150,
                      interval: 25,
                    ),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      zoomMode: ZoomMode.x,
                      enablePanning: true,
                    ),
                    series: state.attempt?.energySeries ??
                        List<LineSeries<Frame, double>>.empty(),
                    annotations: <CartesianChartAnnotation>[
                      if (state.audiosample?.annotations?.isNotEmpty ?? false)
                        CartesianChartAnnotation(
                          widget: FxText.labelSmall(
                            '${annotationAvgEnergy.toStringAsFixed(0)}%',
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(1),
                          ),
                          coordinateUnit: CoordinateUnit.point,
                          x: state
                                  .audiosample
                                  ?.annotations?[state.currentAnnotationIndex]
                                  .segmentStart ??
                              0,
                          y: (state
                                      .audiosample
                                      ?.annotations?[
                                          state.currentAnnotationIndex]
                                      .segmentEnd ??
                                  0) +
                              annotationAvgEnergy +
                              padding,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
