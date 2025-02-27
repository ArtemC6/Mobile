part of 'package:voccent/lens/lens_library.dart';

class TitleButton extends StatelessWidget {
  const TitleButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: mTheme.secondary.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 5,
          ),
        ],
        border: Border.all(
          color: mTheme.secondary,
          width: 0.5,
        ),
        color: FxAppTheme.theme.cardTheme.color,
      ),
      child: FxContainer(
        color: Colors.transparent,
        paddingAll: 6,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: FxText.bodySmall(
            text,
            fontWeight: 700,
            color: mTheme.onSurface.withOpacity(1),
          ),
        ),
      ),
    );
  }
}
