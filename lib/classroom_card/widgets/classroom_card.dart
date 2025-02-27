import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/classroom_card/cubit/classroom_card_cubit.dart';
import 'package:voccent/classroom_card/widgets/classroom_join.dart';
import 'package:voccent/classroom_card/widgets/classroom_plans.dart';
import 'package:voccent/home/cubit/home_cubit.dart';

class ClassroomCard extends StatelessWidget {
  const ClassroomCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassroomCardCubit, ClassroomCardState>(
      builder: _build,
    );
  }

  Widget _build(BuildContext context, ClassroomCardState state) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.user.id == null && current.user.id != null,
      listener: (context, state) {
        context.read<ClassroomCardCubit>().fetchClassroom(state.user);
      },
      child: Scaffold(
        body: BlocBuilder<ClassroomCardCubit, ClassroomCardState>(
          builder: (context, state) {
            if (state.loaded) {
              if (state.user.id == state.classroom?.classroom?.createdby ||
                  state.classroom?.confirmation?.status == 'resolved' ||
                  state.classroom?.confirmation?.status == 'confirmed') {
                return const ClassroomPlans();
              } else {
                return const ClassroomJoin();
              }
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
