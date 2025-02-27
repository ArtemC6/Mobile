part of 'package:voccent/lens/lens_library.dart';

class MyClassroomSquareCard extends StatelessWidget {
  const MyClassroomSquareCard({required this.classroom, this.user, super.key});

  final MyClassroom classroom;
  final User? user;
  static const opacity = .7;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final cache = context.read<ServerAddress>().cacheImgHash();
    final img = Image.network(
      '${context.read<ServerAddress>().httpUri}'
      '/api/v1/asset/object/classroom_picture/${classroom.id}?time=$cache',
      height: 120,
      width: 120,
      opacity: const AlwaysStoppedAnimation(opacity),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/Ccwhitebg.png',
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(opacity),
        height: 120,
        width: 120,
      ),
    );

    return SizedBox(
      width: 120,
      child: Column(
        children: [
          Stack(
            children: [
              FxContainer(
                height: 120,
                color: mTheme.onBackground.withOpacity(0.5),
                onTap: () {
                  context
                      .read<ClassroomSearchCubit>()
                      .setRecentClassroom(classroom.id ?? '');
                  VibrationController.onPressedVibration();
                  GoRouter.of(context).push('/classroom_card/${classroom.id}');
                },
                paddingAll: 0,
                clipBehavior: Clip.hardEdge,
                child: img,
              ),
              if (user?.id == classroom.createdby)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: FxContainer(
                    paddingAll: 4,
                    color: mTheme.background.withOpacity(0.7),
                    borderRadius: BorderRadius.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: FxText.bodySmall(
                        'you owner'.toUpperCase(),
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
                  paddingAll: 4,
                  color: mTheme.background.withOpacity(0.7),
                  borderRadius: BorderRadius.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: FxText.bodyLarge(
                      '${classroom.name}',
                      fontWeight: 700,
                      overflow: TextOverflow.ellipsis,
                      color: mTheme.onSurface.withOpacity(1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
