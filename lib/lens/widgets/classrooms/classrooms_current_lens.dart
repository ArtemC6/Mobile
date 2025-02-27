part of 'package:voccent/lens/lens_library.dart';

class ClassroomsCurrentLens extends StatelessWidget {
  const ClassroomsCurrentLens({
    required this.user,
    super.key,
  });
  final User user;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.classroomFocusId.isEmpty) {
          return const SizedBox.shrink();
        } else {
          final currentOrganizationName = user.focusOrganizationName != null
              ? '#${user.focusOrganizationName}'
              : '';
          return Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HighlightWords().formatSpecialWord(
                  '${S.current.currentClassOrganization}'
                  ' $currentOrganizationName',
                  mTheme,
                ),
                FxSpacing.height(8),
                CurrentClassroomItemCard(
                  id: state.classroomFocusId,
                  name: state.classroomFocusName,
                  user: user,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

String _calculateAccessTime(String startDate) {
  final startDateTime = DateTime.parse(startDate).toUtc();
  final targetDateTime = startDateTime.add(const Duration(days: 3));
  final now = DateTime.now().toUtc();

  final difference = targetDateTime.difference(now);
  if (now.isAfter(targetDateTime)) {
    return '00 days 00 hours';
  }

  if (difference.inHours < 0) {
    return '00 days 00 hours';
  }

  final days = difference.inDays;
  final hours = difference.inHours % 24;

  return '$days days ${hours.toString().padLeft(2, '0')} hours';
}

class CurrentClassroomItemCard extends StatelessWidget {
  const CurrentClassroomItemCard({
    required this.id,
    required this.name,
    required this.user,
    super.key,
  });

  final String id;
  final String name;
  final User user;

  static const opacity = .7;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final cache = context.read<ServerAddress>().cacheImgHash();
    final image = Image.network(
      '${context.read<ServerAddress>().httpUri}'
      '/api/v1/asset/object/classroom_picture/$id?time=$cache',
      alignment: Alignment.topCenter,
      opacity: const AlwaysStoppedAnimation(opacity),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/Ccwhitebg.png',
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(opacity),
      ),
    );

    return Stack(
      children: [
        FxContainer(
          color: mTheme.onBackground,
          onTap: () {
            VibrationController.onPressedVibration();
            GoRouter.of(context).push(
              '/classroom_card/$id',
            );
          },
          paddingAll: 0,
          marginAll: 0,
          clipBehavior: Clip.hardEdge,
          child: image,
        ),
        if (user.focusOrganizationDate != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FxContainer(
              paddingAll: 4,
              color: mTheme.background.withOpacity(0.7),
              borderRadius: BorderRadius.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FxText.bodyLarge(
                  '${S.current.timeLEft} '
                  '${_calculateAccessTime(user.focusOrganizationDate ?? '')}',
                  fontWeight: 700,
                  color: mTheme.secondary,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: FxContainer(
            borderRadius: BorderRadius.zero,
            color: mTheme.background.withOpacity(0.7),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: FxText.titleLarge(
                name.toUpperCase(),
                fontWeight: 700,
                overflow: TextOverflow.ellipsis,
                color: mTheme.onSurface.withOpacity(1),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
