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
  String? _apkFilename;
  String? _apkUrl;
  String? _latestVersion;

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

    if (_requiresUpdate) {
      return MaterialApp(
        title: 'ASM App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: UpdateAppScreen(
          apkFilename: _apkFilename,
          apkUrl: _apkUrl,
          latestVersion: _latestVersion,
        ),
      );
    }
    if (!_hasInternet) {
      return MaterialApp(
        title: 'ASM App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: NoConnectionScreen(
          isRetrying: _isRetrying,
          onRetry: () => _checkConnection(setRetrying: true),
        ),
      );
    }
    // Use MaterialApp.router for GoRouter context
    return MaterialApp.router(
      title: 'ASM App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }

  Future<void> _checkAppUpdate() async {
    // Read current version from pubspec.yaml
    String currentVersion = 'unknown';
    int currentBuildNumber = -1;
    try {
      final pubspec = await File('pubspec.yaml').readAsLines();
      for (final line in pubspec) {
        if (line.trim().startsWith('version:')) {
          currentVersion = line.split(':').last.trim();
          // Extract build number from pubspec.yaml (e.g., 1.0.0+104)
          final parts = currentVersion.split('+');
          if (parts.length == 2) {
            currentBuildNumber = int.tryParse(parts[1]) ?? -1;
          }
          break;
        }
      }
    } catch (_) {}

    try {
      final service = AppUpdateService();
      final info = await service.getLatestVersionInfo();
      final latestVersion = info['version'] as String?;
      final apkFile = info['apk_file'] as String?;
      final apkUrl = info['apk_url'] as String?;
      // Extract build number from update service (e.g., asm_app_ver_104.apk)
      int latestBuildNumber = -1;
      if (latestVersion != null) {
        final regExp = RegExp(r'_(\d+)\.apk');
        final match = regExp.firstMatch(latestVersion);
        if (match != null && match.groupCount >= 1) {
          latestBuildNumber = int.tryParse(match.group(1)!) ?? -1;
        }
      }
      // Only require update if build numbers do not match
      if (latestBuildNumber != -1 && currentBuildNumber != -1 && latestBuildNumber != currentBuildNumber && apkFile != null && apkUrl != null) {
        setState(() {
          _requiresUpdate = true;
          _apkFilename = apkFile;
          _apkUrl = ApiUrl.getFullUrl(apkUrl);
          _latestVersion = latestVersion;
        });
      } else {
        setState(() {
          _requiresUpdate = false;
          _apkFilename = null;
          _apkUrl = null;
          _latestVersion = null;
        });
      }
    } catch (_) {
      setState(() {
        _requiresUpdate = false;
        _apkFilename = null;
        _apkUrl = null;
        _latestVersion = null;
      });
    }
  }

}