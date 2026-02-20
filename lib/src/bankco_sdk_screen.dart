import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BankcoSdkScreen extends StatefulWidget {
  const BankcoSdkScreen({
    super.key,
    required this.url,
    required this.token,
  });

  final String url;
  final String token;

  @override
  State<BankcoSdkScreen> createState() => _BankcoSdkScreenState();
}

class _BankcoSdkScreenState extends State<BankcoSdkScreen> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      return;
    }

    final initialUri = _buildUri(
      inputUrl: widget.url,
      token: widget.token,
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(initialUri);
  }

  Uri _buildUri({
    required String inputUrl,
    required String token,
  }) {
    final uri = Uri.parse(inputUrl);

    final queryParams = <String, String>{
      ...uri.queryParameters,
      'token': token,
      'mod': 'mobSDk',
    };

    return uri.replace(queryParameters: queryParams);
  }

  Future<void> _onBackPressed() async {
    if (!mounted) {
      return;
    }

    // Check if WebView has history to go back
    if (!kIsWeb && _controller != null) {
      final canGoBack = await _controller!.canGoBack();
      if (canGoBack) {
        await _controller!.goBack();
        return;
      }
    }

    // No WebView history, exit the SDK screen
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    // Last resort: exit Flutter app
    if (!kIsWeb) {
      await SystemNavigator.pop();
    }
  }

  Future<bool> _onWillPop() async {
    await _onBackPressed();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isWebUnsupported = kIsWeb;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _onBackPressed,
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Bankco'),
          centerTitle: true,
        ),
        body: isWebUnsupported
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Bankco SDK WebView is supported on Android and iOS. '
                    'Run this screen on a mobile device or emulator.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : WebViewWidget(controller: _controller!),
      ),
    );
  }
}
