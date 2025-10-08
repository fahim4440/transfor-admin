import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/locale/locale_bloc.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

class LanguageToggle extends StatelessWidget {
  final bool isAppbar;
  const LanguageToggle({super.key, required this.isAppbar});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocaleBloc>().state as LocaleInitial;

    final isEnglish = currentLocale.locale.languageCode == 'en';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'En',
          style: TextStyle(
            fontWeight: isEnglish ? FontWeight.bold : FontWeight.normal,
            color: isAppbar ? AppColors.text : AppColors.primary,
          ),
        ),
        Switch(
          value: !isEnglish, // false = English, true = Arabic
          onChanged: (value) {
            final newLocale = value ? const Locale('ar') : const Locale('en');
            context.read<LocaleBloc>().add(ChangeLocale(newLocale));
          },
          activeColor: isAppbar ? AppColors.secondary : AppColors.primary,
        ),
        Text(
          'Ar',
          style: TextStyle(
            fontWeight: !isEnglish ? FontWeight.bold : FontWeight.normal,
            color: isAppbar ? AppColors.text : AppColors.primary,
          ),
        ),
      ],
    );
  }
}
