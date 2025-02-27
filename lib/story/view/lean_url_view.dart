import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LeanUrlView extends StatefulWidget {
  const LeanUrlView(this.uri, {super.key});

  final String uri;

  @override
  State<LeanUrlView> createState() => _LeanUrlViewState();
}

class _LeanUrlViewState extends State<LeanUrlView> {
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
  Widget build(BuildContext context) => WebViewWidget(
        controller: _controller,
      );
}
