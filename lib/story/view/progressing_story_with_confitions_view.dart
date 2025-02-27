import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/story/cubit/models/condition.dart';
import 'package:voccent/story/cubit/story_cubit.dart';

class ProgressingStoryWithConditionsView extends StatelessWidget {
  const ProgressingStoryWithConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final mTheme = Theme.of(context).colorScheme;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: FxContainer(
            width: double.infinity,
            color: Colors.transparent,
            child: Column(
              children: [
                FxSpacing.height(122),
                FxText.bodyLarge(
                  S.current.storyChooseNextAct,
                  color: mTheme.onSurface.withOpacity(1),
                  fontWeight: 800,
                  fontSize: 28,
                ),
                FxSpacing.height(42),
                FxText.titleLarge(
                  state.conditionTimer.toString(),
                  color: mTheme.onSurface.withOpacity(1),
                  fontWeight: 800,
                  fontSize: 30,
                ),
                FxSpacing.height(42),
                Column(
                  children: _buildActConditions(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildActConditions(BuildContext context, StoryState state) {
    return state.currentPass!.actConditions!
        .map((c) => _buildSingleCondition(context, state, c))
        .toList();
  }

  Widget _buildSingleCondition(
    BuildContext context,
    StoryState state,
    Condition condition,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 32,
      ),
      child: RadioListTile<String>(
        title: FxText.bodyMedium(
          condition.actName ?? '',
          color: Theme.of(context).colorScheme.onSurface.withOpacity(1),
          fontSize: 18,
          fontWeight: 700,
        ),
        value: condition.actId!,
        groupValue: state.chosenAct,
        onChanged: (value) =>
            context.read<StoryCubit>().chooseActCondition(value!),
      ),
    );
  }
}
