import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_widget;

class WebViewWidget extends StatefulWidget {
  const WebViewWidget(this._url, {super.key});

  final String _url;

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  late final webview_widget.WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = webview_widget.WebViewController()
      ..setJavaScriptMode(webview_widget.JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget._url));
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: mTheme.onBackground,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: double.infinity,
            child: webview_widget.WebViewWidget(
              controller: _controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: FxContainer(
              onTap: () => Navigator.of(context).pop(),
              borderRadiusAll: 8,
              color: mTheme.primary,
              padding: FxSpacing.xy(82, 11),
              child: FxText.labelLarge(
                S.current.genericReturn,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
