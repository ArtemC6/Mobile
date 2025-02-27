import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/cubit/challenge_favorite_cubit.dart';

class ChallengeFavoritesButton extends StatelessWidget {
  const ChallengeFavoritesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeFavoriteCubit, ChallengeFavoriteState>(
      builder: (context, state) {
        final cubit = context.read<ChallengeFavoriteCubit>();
        final mTheme = Theme.of(context).colorScheme;

        return InkWell(
          onTap: cubit.updateFavorite,
          child: FxContainer(
            color: Colors.transparent,
            child: _buildInnerWidget(
              cubit.state.challengeFavoriteStatus,
              mTheme,
              cubit.state.isChallengeFavorite,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInnerWidget(
    ChallengeFavoriteStatus status,
    ColorScheme mTheme,
    bool isFavorite,
  ) {
    if (status == ChallengeFavoriteStatus.initial ||
        status == ChallengeFavoriteStatus.loading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.more_horiz,
            color: mTheme.onSurface.withOpacity(1),
          ),
        ],
      );
    } else {
      if (isFavorite) {
        return const Icon(
          Icons.favorite,
          color: Colors.red,
        );
      } else {
        return Icon(
          Icons.favorite_outline,
          color: mTheme.onSurface.withOpacity(1),
        );
      }
    }
  }
}
