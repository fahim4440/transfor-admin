import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:transfor_admin_dashboard/models/app_version.dart';
import 'package:transfor_admin_dashboard/utilities/themes.dart';

/// Full-screen blocking page shown when the running app is below the
/// server-mandated minimum version. There is no way to dismiss or skip it —
/// the only way past is to update and relaunch.
class ForceUpdateScreen extends StatefulWidget {
  final AppVersion versionInfo;
  final Future<void> Function() onRetry;

  const ForceUpdateScreen({
    super.key,
    required this.versionInfo,
    required this.onRetry,
  });

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
  bool _checking = false;

  Future<void> _openStore() async {
    final url = widget.versionInfo.storeUrl;
    if (url.isEmpty) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> _retry() async {
    setState(() => _checking = true);
    await widget.onRetry();
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Required',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.system_update, size: 56, color: Colors.orange),
                  const SizedBox(height: 20),
                  const Text(
                    'Update Required',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'A new version of this app is required to continue. '
                    'Please update from the Microsoft Store to keep using it.',
                    textAlign: TextAlign.center,
                  ),
                  if (widget.versionInfo.changelog.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      width: double.infinity,
                      child: Text(widget.versionInfo.changelog),
                    ),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _openStore,
                      child: const Text('Update Now'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: _checking ? null : _retry,
                      child: _checking
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("I've updated — Retry"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
