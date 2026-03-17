import 'services/update/app_update_services.dart';
import 'widgets/update_app_screen.dart';
import 'services/api_url.dart';
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'widgets/no_connection_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _hasInternet = true;
  bool _isRetrying = false;
  bool _requiresUpdate = false;
  String? _updateDownloadUrl;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _checkAppUpdate();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      _,
    ) {
      _checkConnection();
      _checkAppUpdate();
    });
}

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkConnection({bool setRetrying = false}) async {
    if (setRetrying && mounted) {
      setState(() => _isRetrying = true);
    }

    bool connected = false;
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasNetworkInterface = connectivityResult.any(
        (result) => result != ConnectivityResult.none,
      );

      if (hasNetworkInterface) {
        final lookup = await InternetAddress.lookup('google.com');
        connected = lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
      }
    } catch (_) {
      connected = false;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _hasInternet = connected;
      _isRetrying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router(ref);

    return MaterialApp(
      title: 'ASM App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: _requiresUpdate
          ? UpdateAppScreen(downloadUrl: _updateDownloadUrl)
          : _hasInternet
              ? Router.withConfig(config: router)
              : NoConnectionScreen(
                  isRetrying: _isRetrying,
                  onRetry: () => _checkConnection(setRetrying: true),
                ),
    );
  }

  Future<void> _checkAppUpdate() async {
    // Replace with your app's current version
    const int currentVersion = 1; // e.g. 1 for 1.0.0+1
    try {
      final service = AppUpdateService();
      final versions = await service.getAvailableVersions();
      if (versions.isNotEmpty) {
        final latestVersion = versions.first;
        if (latestVersion > currentVersion) {
          setState(() {
            _requiresUpdate = true;
            _updateDownloadUrl = ApiUrl.getFullUrl(ApiUrl.asmAppUpdateDownloadLatest);
          });
        } else {
          setState(() {
            _requiresUpdate = false;
            _updateDownloadUrl = null;
          });
        }
      }
    } catch (_) {
      // If version check fails, allow app usage
      setState(() {
        _requiresUpdate = false;
        _updateDownloadUrl = null;
      });
    }
  }

}