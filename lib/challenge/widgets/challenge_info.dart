import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/challenge/cubit/challenge_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/image_widget.dart';

class ChallengeInfo extends StatelessWidget {
  const ChallengeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<ChallengeCubit, ChallengeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              FxContainer(
                paddingAll: 0,
                marginAll: 0,
                bordered: true,
                borderColor: mTheme.primary,
                borderRadiusAll: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: ImageWidget(
                    serverUri: '${context.read<ServerAddress>().httpUri}',
                    height: 40,
                    width: 40,
                  ).getImageForType('channel', state.challenge!.channelId),
                ),
              ),
              FxSpacing.width(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => GoRouter.of(context).push(
                        '/channel/${context.read<ChallengeCubit>().state.challenge!.channelId}',
                      ),
                      child: FxText.titleMedium(
                        state.challenge?.channelName ?? '',
                        fontWeight: 600,
                        color: mTheme.onSurface.withOpacity(1),
                        overflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    FxSpacing.height(4),
                    FxText.bodySmall(
                      '@${state.challenge?.userName ?? ''}',
                      fontWeight: 600,
                      color: mTheme.onSurface.withOpacity(1),
                      overflow: TextOverflow.ellipsis,
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
