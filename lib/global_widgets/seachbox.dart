import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/orders/orders_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/payout_history/payout_history_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/payout_request/payout_request_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/users/users_bloc.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';

class SearchBox extends StatelessWidget {
  final String searchType;
  final String? userType;
  const SearchBox({super.key, required this.searchType, this.userType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextField(
        onChanged: (val) {
          if (searchType == 'User') {
            context.read<UsersBloc>().add(SearchUsers(searchText: val));
          } else if (searchType == 'Order') {
            context.read<OrdersBloc>().add(SearchOrders(searchText: val));
          } else if (searchType == 'Payout Request') {
            context.read<PayoutRequestBloc>().add(
              SearchPayoutRequest(searchText: val, userType: userType!),
            );
          } else if (searchType == 'Payout History') {
            context.read<PayoutHistoryBloc>().add(
              SearchPayoutHistory(searchText: val),
            );
          }
        },
        decoration: InputDecoration(
          labelText: AppStrings.search.translate(context),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
