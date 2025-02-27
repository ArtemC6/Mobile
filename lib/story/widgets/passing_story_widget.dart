import 'package:flutter/widgets.dart';

// Implement this interface to control the behaviour of StoryWidget
class PassingStoryOptionsProvider {
  const PassingStoryOptionsProvider();
  bool get requiresOverlayPassButton => false;
  bool get requiresFullScreenMode => requiresOverlayPassButton;
}

// For internal usage in StoryWidget
class PassingStoryWidget extends StatelessWidget
    implements PassingStoryOptionsProvider {
  const PassingStoryWidget({
    required this.options,
    required this.child,
    super.key,
  });
  final PassingStoryOptionsProvider options;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  bool get requiresOverlayPassButton => options.requiresOverlayPassButton;

  @override
  bool get requiresFullScreenMode => options.requiresFullScreenMode;
}
