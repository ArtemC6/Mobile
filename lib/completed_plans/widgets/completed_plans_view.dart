import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/completed_plans/cubit/completed_plans_cubit.dart';
import 'package:voccent/completed_plans/widgets/completed_plans_widget.dart';

class CompletedPlansView extends StatelessWidget {
  const CompletedPlansView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CompletedPlansCubit>(
          create: (_) => CompletedPlansCubit(
            client: context.read<UserScopeClient>(),
          ),
        ),
      ],
      child: const CompletedPlansWidget(),
    );
  }
}
