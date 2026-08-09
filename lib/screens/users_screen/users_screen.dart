import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:transfor_admin_dashboard/blocs/users/users_bloc.dart';
import 'package:transfor_admin_dashboard/global_widgets/add_button.dart';
import 'package:transfor_admin_dashboard/global_widgets/seachbox.dart';
import 'package:transfor_admin_dashboard/screens/users_screen/widgets/users_table.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

class UsersScreen extends StatefulWidget {
  final String userType;
  final bool isPending;
  final String? providerTypeFilter;
  final bool showProviderTypeColumn;
  final String? driverTypeFilter;
  const UsersScreen({
    super.key,
    required this.userType,
    this.isPending = false,
    this.providerTypeFilter,
    this.showProviderTypeColumn = false,
    this.driverTypeFilter,
  });

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
    context.read<UsersBloc>().add(
      UsersLoadingInitiate(userType: widget.userType, isPending: widget.isPending),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UsersFailure) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        if (state is UsersLoaded) {
          var visibleUsers = widget.providerTypeFilter == null
              ? state.filteredUsers
              : state.filteredUsers
                  .where((user) => user.providerType?.toLowerCase() == widget.providerTypeFilter)
                  .toList();
          if (widget.driverTypeFilter != null) {
            visibleUsers = visibleUsers
                .where((user) => user.isCompanyDriver == (widget.driverTypeFilter == 'company'))
                .toList();
          }
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SearchBox(searchType: 'User',),
                    if(widget.userType == 'Individual')
                      addButton(AppStrings.addCustomer.translate(context), () {
                        context.go('/add-customer');
                      }),
                    if(widget.userType == 'Service Provider')
                      addButton(AppStrings.addProvider.translate(context), () {
                        context.go('/add-provider');
                      }),
                    if(widget.userType == 'Driver')
                      addButton(AppStrings.addDriver.translate(context), () {
                        context.go('/add-driver');
                      }),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: UsersTable(
                    users: visibleUsers,
                    showProviderTypeColumn: widget.showProviderTypeColumn,
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
