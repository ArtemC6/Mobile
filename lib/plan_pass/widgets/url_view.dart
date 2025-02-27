import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrlView extends StatefulWidget {
  const UrlView(this.uri, {super.key});

  final String uri;

  @override
  State<UrlView> createState() => _UrlViewState();
}

class _UrlViewState extends State<UrlView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget.uri));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mTheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        title: FxText.titleMedium(
          'External link'.toUpperCase(),
          fontWeight: 700,
          textScaleFactor: 1.2257,
          color: mTheme.onPrimaryContainer,
        ),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
