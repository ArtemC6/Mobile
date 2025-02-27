import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final Widget? icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(1.5),
      child: FloatingActionButton(
        elevation: 0.1,
        highlightElevation: 0,
        foregroundColor: mTheme.background,
        splashColor: Theme.of(context).splashColor,
        backgroundColor: isDarkTheme
            ? const Color.fromARGB(255, 37, 37, 37)
            : mTheme.surface,
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      height: 75,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Theme(
          data: ThemeData().copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomAppBar(
            color: isDarkTheme
                ? mTheme.surface.withOpacity(0.20)
                : mTheme.surface.withOpacity(0.65),
            elevation: 0,
            notchMargin: 2,
            shape: const CircularNotchedRectangle(),
            child: child,
          ),
        ),
      ),
    );
  }
}
