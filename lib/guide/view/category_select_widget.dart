import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/feed/cubit/models/category.dart';
import 'package:voccent/feed/view/feed_view.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/guide/cubit/guide_cubit.dart';
import 'package:voccent/guide/view/categories_translate.dart';

const Map<String, String> _categoryImg = <String, String>{
  '': 'assets/images/Ccvoccentbg.png',
  'd441bbf7-be7e-4a0c-9f3d-1aee8271c859':
      'assets/images/voctopics/community.jpeg',
  'f487085e-7e25-47bc-a53b-e7573e154683': 'assets/images/voctopics/travel.jpeg',
  '6a654870-9ea9-4349-a49a-766ddac1ccb5':
      'assets/images/voctopics/business.jpeg',
  '5779d778-944b-4363-ba1e-71061c41c14a':
      'assets/images/voctopics/our world.jpeg',
  '69feee99-b2bb-41e9-9064-86382165f91f': 'assets/images/voctopics/time.jpeg',
  '82934756-54c3-4936-bd4c-5cda7e68c644':
      'assets/images/voctopics/culture.jpeg',
  'aa557b5f-2979-454c-bff8-6281c03177ba': 'assets/images/voctopics/health.jpeg',
  '4880c30a-5928-416f-817e-86c1642969f0': 'assets/images/voctopics/food.jpeg',
  '7d58e8ba-ecc8-4303-8ed4-f7ece7d0063f':
      'assets/images/voctopics/animals.jpeg',
  'e0ce8982-5199-483a-afa8-5743a2d1c329': 'assets/images/voctopics/school.jpeg',
  '241e3607-de8a-4cd2-a37b-2b092a9c7947': 'assets/images/voctopics/family.jpeg',
  'bb353292-c1f4-4fb7-8e11-75723dac1cd2': 'assets/images/voctopics/body.jpeg',
  '5fb26581-a50b-41d4-ad8e-c1914549d059':
      'assets/images/voctopics/meeting new people.jpeg',
  '31e56ccd-2a25-4841-b5df-395c5f430c13':
      'assets/images/voctopics/life abroad.jpeg',
  '0623d8df-7b10-4a4c-a8b6-16cccdf74c01':
      'assets/images/voctopics/grammar.jpeg',
  'c861b185-4df7-400d-b4c3-0063b956879a': 'assets/images/voctopics/life.jpeg',
  'f2145470-eb6c-431e-9743-30e4167d668e':
      'assets/images/voctopics/religion.jpeg',
  '768f363e-5d82-4cc1-a286-72b7b8712742': 'assets/images/voctopics/money.jpeg',
};

class CategorySelectWidget extends StatelessWidget {
  const CategorySelectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 74,
                      sigmaY: 74,
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey.withOpacity(
                          0,
                        ),
                        BlendMode.saturation,
                      ),
                      child: Image.asset(
                        'assets/images/Ccwhitebg.png',
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(.9),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: FxText.titleMedium(
              S.current.filterCategory.toUpperCase(),
              fontWeight: 700,
              textScaleFactor: 1.2257,
              color: mTheme.primary,
            ),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                FeatherIcons.chevronLeft,
                size: 25,
                color: theme.colorScheme.onBackground,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<GuideCubit, GuideState>(
            builder: (context, state) {
              final categories = [
                Category(name: S.current.categoryAllCategories),
                ...state.categories,
              ];

              final selected =
                  context.read<GuideCubit>().state.selectedCategory;

              return GridView.builder(
                padding: FxSpacing.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 210,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (BuildContext context, int index) =>
                    _singleCategory(
                  context,
                  categories[index],
                  _categoryImg[categories[index].id],
                  selected,
                ),
                itemCount: categories.length,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _singleCategory(
    BuildContext context,
    Category item,
    String? image,
    Category selected,
  ) {
    final Widget img;

    if (image is Object) {
      img = Image(
        image: AssetImage(image!),
        height: 210,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      img = ColoredBox(
        color: Theme.of(context).cardColor,
      );
    }

    final String mark;

    if (selected.id == item.id) {
      mark = '✅ ';
    } else {
      mark = '';
    }

    return GestureDetector(
      onTap: () {
        context.read<GuideCubit>().setCategoryFilter(item);
        GoRouter.of(context).push(
          '/feed',
          extra: Parameters(category: item.fullName),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            img,
            Container(
              color: Colors.black.withAlpha(150),
              padding: FxSpacing.xy(16, 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FxText.bodyLarge(
                      mark + translateCategory(item.name),
                      color: Colors.white,
                      fontWeight: 600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
