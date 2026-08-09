import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:transfor_admin_dashboard/blocs/sidebar/sidebar_bloc.dart';
import 'package:transfor_admin_dashboard/global_widgets/language_toggle.dart';
import 'package:transfor_admin_dashboard/services/auth_services.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/assets.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';
import 'package:transfor_admin_dashboard/utilities/text_styles.dart';

class SidebarWidget extends StatelessWidget {
  final String currentRoute;
  const SidebarWidget({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.drawerBgColor,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.padding),
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            BlocBuilder<SidebarBloc, SidebarState>(
              builder: (context, state) {
                if (state is SidebarLoaded) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(Assets.appLogo),
                        radius: AppDimensions.circleAvatarRadius,
                      ),
                      SizedBox(width: AppDimensions.normalSpacing),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppDimensions.lighterSpacing),
                          Text(
                            '${AppStrings.hi.translate(context)}, ${state.admin.name}',
                            style: AppTextStyles.drawerBody,
                          ),
                          SizedBox(height: AppDimensions.normalSpacing),
                          SizedBox(
                            height: AppDimensions.biggerSpacing,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    context.go('/admin-profile');
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.manage_accounts,
                                        color: AppColors.drawerTextColor,
                                      ),
                                      SizedBox(
                                        width: AppDimensions.smallerSpacing,
                                      ),
                                      Text(
                                        AppStrings.account.translate(context),
                                        style: AppTextStyles.drawerBody,
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(width: 10),
                                TextButton(
                                  onPressed: () {
                                    AuthService().logout();
                                    context.go('/login');
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: AppColors.drawerTextColor,
                                      ),
                                      SizedBox(
                                        width: AppDimensions.smallerSpacing,
                                      ),
                                      Text(
                                        AppStrings.logout.translate(context),
                                        style: AppTextStyles.drawerBody,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Divider(),
            listTile(
              icon: Icons.dashboard,
              name: AppStrings.dashboard.translate(context),
              routeName: '/dashboard',
              route: () => context.go('/dashboard'),
            ),
            listTile(
              icon: Icons.person,
              name: AppStrings.customers.translate(context),
              routeName: '/customers',
              route: () => context.go('/customers'),
            ),
            listTile(
              icon: Icons.home_repair_service,
              name: AppStrings.serviceProvider.translate(context),
              routeName: '/provider',
              route: () => context.go('/provider'),
            ),
            listTile(
              icon: Icons.people,
              name: AppStrings.driver.translate(context),
              routeName: '/driver',
              route: () => context.go('/driver'),
            ),
            listTile(
              icon: Icons.shopping_bag,
              name: AppStrings.orders.translate(context),
              routeName: '/orders',
              route: () => context.go('/orders'),
            ),
            listTile(
              icon: Icons.monetization_on,
              name: AppStrings.payoutRequest.translate(context),
              routeName: '/payoutRequest',
              route: () => context.go('/payoutRequest'),
            ),
            listTile(
              icon: Icons.monetization_on,
              name: AppStrings.payoutHistory.translate(context),
              routeName: '/payoutHistory',
              route: () => context.go('/payoutHistory'),
            ),
            listTile(
              icon: Icons.settings,
              name: AppStrings.settings.translate(context),
              routeName: '/settings',
              route: () => context.go('/settings'),
            ),
            listTile(
              icon: Icons.photo_library,
              name: AppStrings.sliderImages.translate(context),
              routeName: '/sliderImages',
              route: () => context.go('/sliderImages'),
            ),
            listTile(
              icon: Icons.local_shipping,
              name: AppStrings.transportTiles.translate(context),
              routeName: '/transportTiles',
              route: () => context.go('/transportTiles'),
            ),
            SizedBox(height: AppDimensions.lighterSpacing),
            LanguageToggle(isAppbar: false,),
          ],
        ),
      ),
    );
  }

  ListTile listTile({
    required IconData icon,
    required String name,
    required String routeName,
    required GestureTapCallback route,
  }) {
    return ListTile(
      selected: currentRoute == routeName,
      selectedTileColor: AppColors.primary,
      leading: Icon(icon, color: AppColors.drawerTextColor),
      title: Text(name, style: AppTextStyles.drawerBody),
      onTap: route,
    );
  }
}
