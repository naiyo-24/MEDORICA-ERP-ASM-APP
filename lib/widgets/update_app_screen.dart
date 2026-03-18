import 'package:asm_app/screens/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class UpdateAppScreen extends StatelessWidget {
  final String? apkFilename;
  final String? apkUrl;
  final String? latestVersion;
  const UpdateAppScreen({super.key, this.apkFilename, this.apkUrl, this.latestVersion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.huge),
          child: Container(
            decoration: AppCardStyles.styleCard(
              backgroundColor: AppColors.white,
              borderRadius: AppBorderRadius.xl,
            ),
            padding: const EdgeInsets.all(AppSpacing.huge),
            child: _UpdateAppContent(
              apkFilename: apkFilename,
              apkUrl: apkUrl,
              latestVersion: latestVersion,
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateAppContent extends StatefulWidget {
  final String? apkFilename;
  final String? apkUrl;
  final String? latestVersion;
  const _UpdateAppContent({this.apkFilename, this.apkUrl, this.latestVersion});

  @override
  State<_UpdateAppContent> createState() => _UpdateAppContentState();
}

class _UpdateAppContentState extends State<_UpdateAppContent> {
  bool _downloading = false;
  double _progress = 0;
  String? _status;

  Future<void> _downloadAndInstallApk() async {
    setState(() {
      _downloading = true;
      _progress = 0;
      _status = 'Downloading...';
    });
    try {
      final dir = await getExternalStorageDirectory();
      final filePath = '${dir!.path}/${widget.apkFilename ?? 'asm-app-latest.apk'}';
      final dio = Dio();
      await dio.download(
        widget.apkUrl!,
        filePath,
        onReceiveProgress: (received, total) {
          setState(() {
            _progress = total > 0 ? received / total : 0;
          });
        },
      );
      setState(() {
        _status = 'Download complete. Installing...';
      });
      await OpenFilex.open(filePath);
      setState(() {
        _status = 'APK opened for install.';
        _downloading = false;
      });
      // Restart app to splash screen after install
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
        );
      });
    } catch (e) {
      setState(() {
        _status = 'Failed: ${e.toString()}';
        _downloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Icon(Icons.update, size: 64, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'A new version (${widget.latestVersion ?? ''}) of the ASM App is available!',
          style: AppTypography.h3.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Please update to continue using the app.',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.quaternary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.huge),
        if (_downloading)
          Column(
            children: [
              LinearProgressIndicator(value: _progress),
              const SizedBox(height: AppSpacing.md),
              Text(_status ?? '', style: AppTypography.bodySmall),
            ],
          )
        else
          ElevatedButton.icon(
            icon: const Icon(Iconsax.document_download, size: 24),
            label: Text('Download Update', style: AppTypography.buttonLarge),
            onPressed: widget.apkUrl != null ? _downloadAndInstallApk : null,
            style: AppButtonStyles.primaryButton(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              height: 48,
              borderRadius: AppBorderRadius.lg,
            ),
          ),
      ],
    );
  }
}

