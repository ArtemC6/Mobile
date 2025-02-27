import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/feed/cubit/models/feed_model/feed_model.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/root/root_widget.dart';
import 'package:voccent/widgets/image_widget.dart';
import 'package:voccent/widgets/loading_effect.dart';
import 'package:voccent/widgets/vibration_controller.dart';

class FeedSearchResult extends StatelessWidget {
  const FeedSearchResult({
    required this.query,
    super.key,
  });
  final String? query;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedCubit(
        context.read<UserScopeClient>(),
        context.read<SharedPreferences>(),
        context.read<HomeCubit>().userLanguages(),
        context.read<HomeCubit>().state.user.currentlang ?? [],
        Dictionary.platformLanguageId(),
      )..setQuery(query ?? ''),
      child: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state.itemsCount == 0) {
            return Container();
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = context.read<FeedCubit>().feedItem(index);
                    if (item.isLoading()) {
                      return LoadingEffect.getFeedResultsLoading(
                        context,
                      );
                    }

                    return FeedCard(item: item);
                  },
                  itemCount: state.itemsCount,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class FeedCard extends StatelessWidget {
  const FeedCard({
    required this.item,
    super.key,
  });

  final FeedModel item;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final itemId =
        item.type == 'playlist' ? item.object?.pictureIdFirst : item.id;
    final image = ImageWidget(
      serverUri: '${context.read<ServerAddress>().httpUri}',
      height: 120,
      width: 120,
    ).getImageForType(item.type ?? '', itemId ?? '');
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 120,
        child: Stack(
          children: [
            FxContainer(
              color: mTheme.onBackground.withOpacity(0.5),
              height: 120,
              onTap: () {
                VibrationController.onPressedVibration();
                GoRouter.of(context).push(
                  '/${item.type}/${item.id}',
                );
              },
              paddingAll: 0,
              marginAll: 0,
              clipBehavior: Clip.hardEdge,
              child: image,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FxContainer(
                color: mTheme.background.withOpacity(0.7),
                child: FxText.bodyLarge(
                  '${item.object?.name}',
                  overflow: TextOverflow.ellipsis,
                  color: mTheme.onSurface.withOpacity(1),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
