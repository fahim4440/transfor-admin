import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfor_admin_dashboard/blocs/dashboard/dashboard_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/locale/locale_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/orders/orders_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/payout_history/payout_history_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/payout_request/payout_request_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/setting/setting_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/sidebar/sidebar_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/user_info/user_info_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/users/users_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'services/localizations.dart';
import 'services/router.dart';
import 'utilities/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved locale from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('locale') ?? 'en';
  Locale locale = Locale(savedLocaleCode);
  runApp(AdminApp(initialLocale: locale,));
}

class AdminApp extends StatelessWidget {
  final Locale initialLocale;
  const AdminApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(
          create: (_) => LocaleBloc()..add(ChangeLocale(initialLocale)),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc()..add(CheckLoginStatus()),
        ),
        BlocProvider<SidebarBloc>(
          create: (_) => SidebarBloc()..add(SidebarInitiate()),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc()..add(DashboardInitiate()),
        ),
        BlocProvider<UsersBloc>(
          create: (_) => UsersBloc(),
        ),
        BlocProvider<UserInfoBloc>(
          create: (_) => UserInfoBloc(),
        ),
        BlocProvider<OrdersBloc>(
          create: (_) => OrdersBloc(),
        ),
        BlocProvider<PayoutRequestBloc>(
          create: (_) => PayoutRequestBloc(),
        ),
        BlocProvider<PayoutHistoryBloc>(
          create: (_) => PayoutHistoryBloc(),
        ),
        BlocProvider<SettingBloc>(
          create: (_) => SettingBloc(),
        )
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          if (state is LocaleInitial) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'TransFor Admin',
              theme: AppTheme.lightTheme,
              routerConfig: appRouter,
              locale: state.locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
