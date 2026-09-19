import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/global_widgets/textField.dart';
import 'package:transfor_admin_dashboard/models/app_version.dart';
import 'package:transfor_admin_dashboard/services/app_update_services.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

import 'save_button.dart';

/// Lets an admin edit the force-update config for both windows apps
/// (provider and admin) that share the app_versions table.
class AppVersionsSection extends StatefulWidget {
  const AppVersionsSection({super.key});

  @override
  State<AppVersionsSection> createState() => _AppVersionsSectionState();
}

class _AppVersionsSectionState extends State<AppVersionsSection> {
  final AppUpdateServices _service = AppUpdateServices();
  bool _loading = true;
  List<AppVersion> _versions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final versions = await _service.fetchAllAppVersions();
    if (mounted) {
      setState(() {
        _versions = versions;
        _loading = false;
      });
    }
  }

  void _showMessage(bool success, String message) {
    AwesomeDialog(
      context: context,
      dialogType: success ? DialogType.success : DialogType.error,
      title: success ? 'Saved' : 'Failed',
      desc: message,
      btnOkOnPress: () {},
      width: 400,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'App Force-Update',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Users on a version below "Minimum version" are blocked until they update. '
          '"Force update" blocks everyone regardless of version — an emergency kill-switch.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else
          ..._versions.map(
            (version) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _AppVersionCard(
                version: version,
                onSave: (updated) async {
                  final ok = await _service.saveAppVersion(updated);
                  _showMessage(ok, ok ? '${updated.appKey} updated' : 'Could not save ${updated.appKey}');
                  if (ok) _load();
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _AppVersionCard extends StatefulWidget {
  final AppVersion version;
  final Future<void> Function(AppVersion updated) onSave;

  const _AppVersionCard({required this.version, required this.onSave});

  @override
  State<_AppVersionCard> createState() => _AppVersionCardState();
}

class _AppVersionCardState extends State<_AppVersionCard> {
  late final TextEditingController _latestController;
  late final TextEditingController _minController;
  late final TextEditingController _storeUrlController;
  late final TextEditingController _changelogController;
  late bool _forceUpdate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _latestController = TextEditingController(text: widget.version.latestVersion);
    _minController = TextEditingController(text: widget.version.minVersion);
    _storeUrlController = TextEditingController(text: widget.version.storeUrl);
    _changelogController = TextEditingController(text: widget.version.changelog);
    _forceUpdate = widget.version.forceUpdate;
  }

  @override
  void dispose() {
    _latestController.dispose();
    _minController.dispose();
    _storeUrlController.dispose();
    _changelogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.version.appKey,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: textFieldDisabled(
                  labelText: 'Latest version',
                  textController: _latestController,
                  isReadOnly: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: textFieldDisabled(
                  labelText: 'Minimum version (below this is blocked)',
                  textController: _minController,
                  isReadOnly: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          textFieldDisabled(
            labelText: 'Store URL (ms-windows-store://pdp/?productid=...)',
            textController: _storeUrlController,
            isReadOnly: false,
          ),
          const SizedBox(height: 10),
          textFieldDisabled(
            labelText: 'Changelog (shown on the update screen)',
            textController: _changelogController,
            isReadOnly: false,
          ),
          const SizedBox(height: 4),
          CheckboxListTile(
            value: _forceUpdate,
            onChanged: (value) => setState(() => _forceUpdate = value ?? false),
            title: const Text('Force update (blocks everyone right now)'),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: saveButton(
              text: _saving ? 'Saving...' : 'Save',
              onPressed: _saving
                  ? null
                  : () async {
                      setState(() => _saving = true);
                      await widget.onSave(
                        widget.version.copyWith(
                          latestVersion: _latestController.text.trim(),
                          minVersion: _minController.text.trim(),
                          storeUrl: _storeUrlController.text.trim(),
                          changelog: _changelogController.text.trim(),
                          forceUpdate: _forceUpdate,
                        ),
                      );
                      if (mounted) setState(() => _saving = false);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
