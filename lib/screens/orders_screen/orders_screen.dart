import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/orders/orders_bloc.dart';
import 'package:transfor_admin_dashboard/screens/orders_screen/widgets/orders_table.dart';

import '../../utilities/app_strings.dart';
import '../../utilities/dimensions.dart';
import '../../global_widgets/seachbox.dart';

class OrdersScreen extends StatefulWidget {
  final String ordersCompletedTyep;
  const OrdersScreen({super.key, required this.ordersCompletedTyep});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
    context.read<OrdersBloc>().add(OrdersLoadingInitiate(ordersCompleteType: widget.ordersCompletedTyep));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrdersFailure) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        if (state is OrdersLoaded) {
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [SearchBox(searchType: 'Order')],
                ),
                const SizedBox(height: 16),
                Expanded(child: OrdersTable(orders: state.filteredOrders)),
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
