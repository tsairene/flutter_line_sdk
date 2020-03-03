import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'webview_page.dart';

class WebViewTestPage extends StatefulWidget {
  @override
  _WebViewTestPageState createState() => _WebViewTestPageState();
}

class _WebViewTestPageState extends State<WebViewTestPage> with AutomaticKeepAliveClientMixin {
  Map<String, String> _shoppingUrls = {
    'alpha': 'https://buy.line-alpha.me/',
    'beta': 'https://buy.line-beta.me/',
    'rc': 'https://buy.line-rc.me/',
    'real': 'https://buy.line.me/',
    'others': 'https://'
  };
  List<DropdownMenuItem<String>> _urlDropDownMenuItems;
  TextEditingController _urlTextController;
  TextEditingController _cookiePlatformTextController;
  TextEditingController _cookieAccessTokenTextController;

  String _currentEnvironment;

  @override
  void initState() {
    super.initState();
    _urlDropDownMenuItems = getUrlDropDownMenuItems();
    _currentEnvironment = _urlDropDownMenuItems[3].value;
    _urlTextController = new TextEditingController(text: _currentEnvironment);
    _cookiePlatformTextController = new TextEditingController(text: 'TW Shopping App');
    _cookieAccessTokenTextController = new TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              'Url Address',
              textAlign: TextAlign.start,
            ),
            Divider(),
            DropdownButton(
              value: _currentEnvironment,
              items: _urlDropDownMenuItems,
              onChanged: changedDropDownItem,
            ),
            Divider(),
            TextField(
              controller: _urlTextController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'url',
              ),
            ),
            Divider(),
            Text(
              'Cookie',
              textAlign: TextAlign.start,
            ),
            Divider(),
            TextField(
              controller: _cookiePlatformTextController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'platform',
              ),
            ),
            Divider(),
            TextField(
              controller: _cookieAccessTokenTextController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'access_token',
              ),
            ),
            RaisedButton(
              child: Text('load url with cookie'),
              onPressed: () {
                launchWebViewPage(context, _urlTextController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  List<DropdownMenuItem<String>> getUrlDropDownMenuItems() =>
      _shoppingUrls.entries.map((entry) => DropdownMenuItem(value: entry.value, child: new Text(entry.key))).toList();

  void changedDropDownItem(String selectedEnvironment) {
    setState(() {
      _currentEnvironment = selectedEnvironment;
      _urlTextController.text = _currentEnvironment;
    });
  }

  void launchWebViewPage(BuildContext context, String url) {
    debugPrint('[launchWebViewPage] $url');
    Navigator.push<WebViewPage>(
      context,
      MaterialPageRoute<WebViewPage>(builder: (context) => WebViewPage(initialUrl: url)),
    );
  }
}
