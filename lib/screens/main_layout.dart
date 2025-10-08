import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

import '../global_widgets/language_toggle.dart';
import '../global_widgets/sidebar_widget.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final String currentRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.toString();

    return Scaffold(
      appBar:
          isDesktop
              ? null
              : AppBar(
                backgroundColor: AppColors.primary,
                elevation: 2,
                title: Text(AppStrings.dashboard.translate(context)),
                actions: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: LanguageToggle(isAppbar: true),
                  ),
                ],
              ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            SizedBox(
              width: 318,
              child: SidebarWidget(currentRoute: currentRoute),
            ),
          Expanded(child: child),
        ],
      ),
      drawer:
          isDesktop
              ? null
              : SizedBox(
                width: 318,
                child: SidebarWidget(currentRoute: currentRoute),
              ),
    );
  }
}
