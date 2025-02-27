import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationFallbackWebView extends StatefulWidget {
  const NavigationFallbackWebView(this._url, {super.key});

  final String _url;

  @override
  State<NavigationFallbackWebView> createState() =>
      _NavigationFallbackWebViewState();
}

class _NavigationFallbackWebViewState extends State<NavigationFallbackWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget._url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).go('/'),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () => Share.share(widget._url),
              icon: const Icon(FeatherIcons.share2),
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
