import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/home/cubit/models/user/user.dart';

class Gamification extends StatelessWidget {
  const Gamification({
    required this.user,
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    const timeProgress = 0.9;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    FxText(
                      '2:32  Time',
                      fontSize: 16,
                      fontWeight: 600,
                      color: mTheme.primary,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: timeProgress,
                      minHeight: 5,
                      color: mTheme.primary,
                      backgroundColor: Colors.grey.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    FxText(
                      '${user.xpTotal} XP',
                      fontSize: 16,
                      fontWeight: 600,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: 0.8,
                      minHeight: 5,
                      color: Colors.amberAccent,
                      backgroundColor: Colors.grey.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
