import 'package:bankco_flutter_sdk/bankco_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bankco SDK Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  static const String _integrationUrl = 'http://indianoil.bankco.co.in/';

  Future<String> _fetchTokenFromBackend() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return '1111111wertwe1';
  }

  Future<String> _fetchCardIdFromBackend() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return 'card_123';
  }

  Future<void> _openBankcoSdk() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _fetchTokenFromBackend();
      final cardId = await _fetchCardIdFromBackend();
      if (!mounted) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BankcoSdkScreen(
            url: _integrationUrl,
            token: token,
            cardId: cardId,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Host App')),
      body: PopScope(
        canPop: Navigator.of(context).canPop(),
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          SystemNavigator.pop();
        },
        child: Center(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _openBankcoSdk,
            child: Text(_isLoading ? 'Loading...' : 'Open Bankco SDK'),
          ),
        ),
      ),
    );
  }
}
