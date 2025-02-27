part of 'package:voccent/lens/lens_library.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    required this.onPressed,
    super.key,
  });
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return AnimationConfiguration.staggeredList(
      position: 5,
      child: FadeInAnimation(
        duration: const Duration(
          milliseconds: 500,
        ),
        child: FxContainer(
          color: isDarkTheme
              ? FxAppTheme.theme.cardTheme.color
              : mTheme.onPrimary.withOpacity(0.75),
          height: 250,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              FeatherIcons.search,
              color: mTheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
