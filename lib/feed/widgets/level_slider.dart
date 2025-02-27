import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';

class LevelSlider extends StatelessWidget {
  const LevelSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedCubit>();
    final mTheme = Theme.of(context).colorScheme;

    var currentRangeValues = RangeValues(
      cubit.state.levelFrom.toDouble(),
      cubit.state.levelTo.toDouble(),
    );
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        currentRangeValues = RangeValues(
          state.levelFrom.toDouble(),
          state.levelTo.toDouble(),
        );
        return RangeSlider(
          values: currentRangeValues,
          min: 1,
          max: 100,
          divisions: 100,
          onChanged: context.read<FeedCubit>().setLevelFilter,
          labels: RangeLabels(
            state.levelFrom.toString(),
            state.levelTo.toString(),
          ),
          activeColor: mTheme.primary,
        );
      },
    );
  }
}
