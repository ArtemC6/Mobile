import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/challenge/cubit/rating_cubit.dart';

class ChallengeRatingButton extends StatelessWidget {
  const ChallengeRatingButton({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<RatingCubit, RatingState>(
        builder: (context, state) {
          final cubit = context.read<RatingCubit>();
          final mTheme = Theme.of(context).colorScheme;

          return FxContainer(
            alignment: Alignment.centerLeft,
            color: Colors.transparent,
            child: state.loadingRating
                ? Icon(
                    Icons.more_horiz,
                    size: 16,
                    color: mTheme.onSecondary,
                  )
                : RatingBar.builder(
                    initialRating: state.rating ?? 0,
                    minRating: 1,
                    itemPadding: const EdgeInsets.only(right: 6),
                    itemBuilder: (context, i) {
                      if (i < (state.rating ?? 0)) {
                        return Icon(
                          Icons.star,
                          color: mTheme.secondary,
                        );
                      }
                      return Icon(
                        Icons.star_border_outlined,
                        color: mTheme.secondary,
                      );
                    },
                    unratedColor: mTheme.onSurface.withOpacity(1),
                    onRatingUpdate: cubit.updateRating,
                    itemSize: 24,
                  ),
          );
        },
      );
}
