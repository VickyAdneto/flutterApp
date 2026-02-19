import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BankcoSdkScreen extends StatefulWidget {
  const BankcoSdkScreen({
    super.key,
    required this.url,
    this.uid,
    this.tokenParamName = 'token',
    this.title = 'Bankco',
    this.enableWebHistoryOnBack = false,
  });

  final String url;
  final String? uid;
  final String tokenParamName;
  final String title;
  final bool enableWebHistoryOnBack;

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
      tokenParamName: widget.tokenParamName,
      uid: widget.uid,
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(initialUri);
  }

  Uri _buildUri({
    required String inputUrl,
    required String tokenParamName,
    required String? uid,
  }) {
    final uri = Uri.parse(inputUrl);
    if (uid == null || uid.isEmpty) {
      return uri;
    }

    final queryParams = <String, String>{
      ...uri.queryParameters,
      tokenParamName: uid,
    };

    return uri.replace(queryParameters: queryParams);
  }

  Future<void> _onBackPressed() async {
    if (!widget.enableWebHistoryOnBack || kIsWeb) {
      if (mounted) {
        Navigator.of(context).maybePop();
      }
      return;
    }

    final controller = _controller;
    if (controller == null) {
      return;
    }

    final canGoBack = await controller.canGoBack();
    if (canGoBack) {
      await controller.goBack();
      return;
    }

    if (mounted) {
      Navigator.of(context).maybePop();
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
          title: Text(widget.title),
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
