import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/classroom/cubit/classroom_cubit.dart';
import 'package:voccent/classroom/widgets/classroom_widget.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/web_socket/web_socket.dart';

class ClassroomView extends StatelessWidget {
  const ClassroomView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ClassroomCubit(
          context.read<WebSocket>(),
          context.read<AuthCubit>().state.userToken,
          context.read<HomeCubit>().state.user,
          context.read<UserScopeClient>(),
        )..loadClassrooms();
      },
      lazy: false,
      child: ClassroomWidget(),
    );
  }
}
