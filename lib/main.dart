import 'package:flutter/foundation.dart';
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
import 'package:transfor_admin_dashboard/blocs/slider_images/slider_images_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/tile_images/tile_images_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/user_info/user_info_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/users/users_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'models/app_version.dart';
import 'screens/force_update_screen.dart';
import 'services/app_update_services.dart';
import 'services/localizations.dart';
import 'services/router.dart';
import 'utilities/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved locale from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('locale') ?? 'en';
  Locale locale = Locale(savedLocaleCode);
  runApp(AppUpdateGate(initialLocale: locale));
}

/// Blocks the whole app behind [ForceUpdateScreen] when the running build is
/// below the server-mandated minimum version. The check fails open — a
/// network error never blocks the app, only an explicit server response does.
class AppUpdateGate extends StatefulWidget {
  final Locale initialLocale;
  const AppUpdateGate({super.key, required this.initialLocale});

  @override
  State<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends State<AppUpdateGate> {
  final AppUpdateServices _appUpdateServices = AppUpdateServices();
  bool _loading = true;
  AppVersion? _blockingVersionInfo;

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    setState(() => _loading = true);

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      final versionInfo = await _appUpdateServices.checkAppVersion(AppUpdateServices.adminAppKey);
      if (versionInfo != null) {
        final current = await _appUpdateServices.currentVersion();
        final blocked = versionInfo.forceUpdate ||
            AppUpdateServices.isBelowMinVersion(current, versionInfo.minVersion);
        _blockingVersionInfo = blocked ? versionInfo : null;
      } else {
        _blockingVersionInfo = null;
      }
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (_blockingVersionInfo != null) {
      return ForceUpdateScreen(
        versionInfo: _blockingVersionInfo!,
        onRetry: _checkVersion,
      );
    }

    return AdminApp(initialLocale: widget.initialLocale);
  }
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
        ),
        BlocProvider<SliderImagesBloc>(
          create: (_) => SliderImagesBloc(),
        ),
        BlocProvider<TileImagesBloc>(
          create: (_) => TileImagesBloc(),
        ),
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
