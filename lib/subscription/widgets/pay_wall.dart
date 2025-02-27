import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/subscription/cubit/models/current_subscription/value.dart';
import 'package:voccent/subscription/cubit/subscription_cubit.dart';
import 'package:voccent/widgets/dialog.dart';

class PayWall extends StatelessWidget {
  const PayWall({
    required this.child,
    required this.capabilityId,
    super.key,
  });

  final Widget child;
  final String capabilityId;

  @override
  Widget build(BuildContext context) {
    final cap = context
        .read<SubscriptionCubit>()
        .capabilityValue(
          capabilityId,
          context.read<HomeCubit>().state.user.worklang,
        )
        .string;

    final paid = cap == null || cap == Value.yes;

    if (paid) {
      return child;
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        AbsorbPointer(child: child),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(),
          ),
        ),
        const SubscriptionDialog(),
      ],
    );
  }
}
