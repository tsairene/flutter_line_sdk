import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({@required String initialUrl}) : _initialUrl = initialUrl;
  final String _initialUrl;

  @override
  _WebViewPageState createState() => _WebViewPageState(_initialUrl);
}

class _WebViewPageState extends State<WebViewPage> with AutomaticKeepAliveClientMixin<WebViewPage> {
  _WebViewPageState(this._initialUrl);

  final String _initialUrl;

  static const String webViewTitle = 'WebView Page';
  static const String cookieKeyPlatform = 'platform';
  static const String cookieValuePlatform = 'TW Shopping App';

  InAppWebViewController _webViewController;
  CookieManager _cookieManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cookieManager = CookieManager.instance();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: _onHandleBackHistory,
      child: Scaffold(
        appBar: AppBar(title: const Text(webViewTitle)),
        body: Container(
          child: InAppWebView(
            initialUrl: _initialUrl,
            initialOptions: InAppWebViewWidgetOptions(
              crossPlatform: InAppWebViewOptions(
                debuggingEnabled: !kReleaseMode,
                userAgent: cookieValuePlatform,
              ),
            ),
            onWebViewCreated: (controller) async {
              _webViewController = controller;
              await _cookieManager.setCookie(url: _initialUrl, name: cookieKeyPlatform, value: cookieValuePlatform);
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<bool> _onHandleBackHistory() async {
    final bool canGoBack = await _webViewController.canGoBack();
    if (canGoBack) {
      _webViewController.goBack();
      return false;
    }
    return true;
  }
}
