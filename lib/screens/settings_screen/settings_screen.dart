import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/setting/setting_bloc.dart';
import 'package:transfor_admin_dashboard/global_widgets/textField.dart';
import 'package:transfor_admin_dashboard/models/settings.dart';
import 'package:transfor_admin_dashboard/screens/settings_screen/widgets/save_button.dart';

import '../../utilities/app_strings.dart';
import '../../utilities/dimensions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _pChargeTextController = TextEditingController();
  final TextEditingController _taxTextController = TextEditingController();

  void _showError(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: AppStrings.loginFailed.translate(context),
      desc: message,
      btnOkOnPress: () {},
      width: 400,
    ).show();
  }

  @override
  void initState() {
    super.initState();
    context.read<SettingBloc>().add(SettingLoadingInitiate());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state is SettingFailure) {
          _showError(state.message);
        } else if (state is SettingLoaded) {
          _pChargeTextController.text = state.setting.deliveryCharge;
          _taxTextController.text = state.setting.tax;
        }
      },
      builder: (context, state) {
        if (state is SettingLoaded) {
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: textFieldDisabled(labelText: AppStrings.platformCharge.translate(context), textController: _pChargeTextController, isReadOnly: false)
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: textFieldDisabled(labelText: AppStrings.tax.translate(context), textController: _taxTextController, isReadOnly: false)
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: saveButton(
                    text: AppStrings.save.translate(context),
                    onPressed:
                        () => context.read<SettingBloc>().add(
                          SaveSetting(
                            setting: Setting(
                              id: state.setting.id,
                              deliveryCharge: _pChargeTextController.text,
                              tax: _taxTextController.text,
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
