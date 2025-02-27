import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/guide/cubit/guide_cubit.dart';
import 'package:voccent/guide/view/category_select_widget.dart';

class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GuideCubit(
        context.read<UserScopeClient>(),
      )..loadFilters(),
      child: const CategorySelectWidget(),
    );
  }
}
