import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/story/cubit/story_cubit.dart';
import 'package:voccent/story/view/simantic_user_view.dart';

class SemanticAnalysisView extends StatelessWidget {
  const SemanticAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        return const SemanticUserView();
      },
    );
  }
}
