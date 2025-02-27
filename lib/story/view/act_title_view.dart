import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/story/cubit/story_cubit.dart';

class ActTitleView extends StatefulWidget {
  const ActTitleView({super.key});

  @override
  State<ActTitleView> createState() => _ActTitleViewState();
}

class _ActTitleViewState extends State<ActTitleView> {
  @override
  Widget build(BuildContext context) => BlocBuilder<StoryCubit, StoryState>(
        builder: (context, state) =>
            FxText.titleLarge(state.currentPass!.actName ?? ''),
      );
}
