import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/users/users_bloc.dart';
import 'package:transfor_admin_dashboard/global_widgets/add_button.dart';
import 'package:transfor_admin_dashboard/global_widgets/seachbox.dart';
import 'package:transfor_admin_dashboard/screens/users_screen/widgets/users_table.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

class UsersScreen extends StatefulWidget {
  final String userType;
  const UsersScreen({super.key, required this.userType});

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
      UsersLoadingInitiate(userType: widget.userType),
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
                      addButton(AppStrings.addUser.translate(context), () {}),
                    if(widget.userType == 'Service Provider')
                      addButton(AppStrings.addProvider.translate(context), () {}),
                    if(widget.userType == 'Driver')
                      addButton(AppStrings.addDriver.translate(context), () {}),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(child: UsersTable(users: state.filteredUsers)),
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
