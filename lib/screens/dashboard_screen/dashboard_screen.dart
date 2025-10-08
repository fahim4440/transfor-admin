import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/dashboard/dashboard_bloc.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

import '../../utilities/app_strings.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //showing Error
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 800 ? 2 : 4;

    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardFailure) {
          _showError(state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is DashboardLoaded) {
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 16,
              children: [
                StatCard(
                  title: AppStrings.users.translate(context),
                  value: state.allCount.users,
                  icon: Icons.person,
                ),
                StatCard(
                  title: AppStrings.providers.translate(context),
                  value: state.allCount.providers,
                  icon: Icons.home_repair_service,
                ),
                StatCard(
                  title: AppStrings.driver.translate(context),
                  value: state.allCount.drivers,
                  icon: Icons.people,
                ),
                StatCard(
                  title: AppStrings.products.translate(context),
                  value: state.allCount.products,
                  icon: Icons.shopping_cart,
                ),
                StatCard(
                  title: AppStrings.services.translate(context),
                  value: state.allCount.services,
                  icon: Icons.settings_suggest,
                ),
                StatCard(
                  title: AppStrings.ongoingOrders.translate(context),
                  value: state.allCount.onGoingOrders,
                  icon: Icons.shopping_bag,
                ),
                StatCard(
                  title: AppStrings.completedOrders.translate(context),
                  value: state.allCount.pastOrder,
                  icon: Icons.check_box,
                ),
                StatCard(
                  title: AppStrings.cancelledOrders.translate(context),
                  value: state.allCount.cancelOrder,
                  icon: Icons.indeterminate_check_box,
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
