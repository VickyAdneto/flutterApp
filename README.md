# bankco_flutter_sdk

Flutter mobile SDK for embedding your web flow inside a Flutter app.

This SDK shows:
- A navigation bar with a back button
- Product name title: `Bankco`
- An in-app WebView loading the URL provided by integrator app

## URL behavior

The integrator provides the base URL and token:

```dart
BankcoSdkScreen(
  url: 'http://indianoil.bankco.co.in/',
  token: 'yourBackendToken',
)
```

SDK automatically appends query parameters.

Loaded URL becomes:

`http://indianoil.bankco.co.in/?token=yourBackendToken&mod=sdk`

The `mod=sdk` parameter is automatically added by the SDK to identify mobile SDK traffic.

## Integration requirements

The SDK requires only two inputs from integrators:

- `url`: Your web flow base URL
- `token`: Backend-generated user/session token

The SDK automatically injects these query parameters:

- `token`: The token you provided

Final URL format:

`http://indianoil.bankco.co.in/?token=<yourtoken>&mod=sdk`

## Quick integration checklist

- Pass base URL in `url` (for example: `http://indianoil.bankco.co.in/`)
- Pass backend token in `token`
- Open `BankcoSdkScreen` using `Navigator.push`
- If using `http`, apply Android and iOS cleartext/ATS settings below

## Install

Add dependency in host app `pubspec.yaml`:

```yaml
dependencies:
  bankco_flutter_sdk:
    path: ../bankco_flutter_sdk
```

Then run:

```bash
flutter pub get
```

## Integrate in host app

```dart
import 'package:bankco_flutter_sdk/bankco_flutter_sdk.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> fetchTokenFromBackend() async {
    // Replace with your API call.
    return '1111111wertwe1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Host App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final token = await fetchTokenFromBackend();
            if (!context.mounted) return;

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BankcoSdkScreen(
                  url: 'http://indianoil.bankco.co.in/',
                  token: token,
                ),
              ),
            );
          },
          child: const Text('Open Bankco SDK'),
        ),
      ),
    );
  }
}
```

## API

`BankcoSdkScreen` parameters:

- `url` (required): Base URL to open in WebView
- `token` (required): Backend-generated token value

The SDK automatically appends:
- `token` as a query parameter

Example:

```dart
BankcoSdkScreen(
  url: 'https://your-domain.com/flow',
  token: tokenFromBackend,
)
```

## Back button behavior

- App bar back and device back close SDK screen and return to host app page.

## How other Flutter apps can integrate this SDK

1. Publish SDK to git and add dependency in host app `pubspec.yaml`:

```yaml
dependencies:
  bankco_flutter_sdk:
    git:
      url: <your-private-or-public-git-repo-url>
      ref: main
```

2. Get `url` and `token` from host app/backend as per business flow.
3. Open SDK screen from any Flutter page:

```dart
Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => BankcoSdkScreen(
      url: urlFromIntegrator,
      token: tokenFromBackend,
    ),
  ),
);
```

4. Ensure platform setup:
- Android: `android:usesCleartextTraffic="true"` if using `http` URL.
- iOS: add `NSAppTransportSecurity` if using `http` URL.

## Platform notes

### Flutter Web

`webview_flutter` is for mobile WebView usage. This SDK is intended for Android and iOS.
When run on Chrome/web, the SDK shows a fallback message instead of crashing.

### Android

Because `http` URLs are blocked by default on Android 9+, enable cleartext traffic in host app
`android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="your_app_name"
    android:usesCleartextTraffic="true">
```

### iOS (important for HTTP URL)

`http` URLs are blocked by default. Add this to host app `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

If possible, move production URL to HTTPS.

## Runnable example app

A full host app is included at:

`example/`

Run it:

```bash
cd example
flutter pub get
flutter run
```

Entry file:

`example/lib/main.dart`
