import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:transfor_admin_dashboard/blocs/users/users_bloc.dart';
import 'package:transfor_admin_dashboard/models/users_profile.dart';
import 'package:transfor_admin_dashboard/screens/users_screen/widgets/button.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/text_styles.dart';

class UsersTable extends StatefulWidget {
  final List<UserProfile> users;
  const UsersTable({super.key, required this.users});

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  int rowIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingTextStyle: AppTextStyles.whiteNormalText,
          headingRowColor: WidgetStateColor.resolveWith(
            (states) => AppColors.primary,
          ),
          sortAscending: _isSortAsc,
          sortColumnIndex: _currentSortColumn,
          dividerThickness: 0.0,
          dataRowMaxHeight: 80,
          columns: [
            DataColumn(label: Text(AppStrings.no.translate(context))),
            DataColumn(
              label: Text(AppStrings.name.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.users.sort((a, b) => b.name.compareTo(a.name));
                  } else {
                    widget.users.sort((a, b) => a.name.compareTo(b.name));
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.mobile.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.users.sort((a, b) => b.mobile.compareTo(a.mobile));
                  } else {
                    widget.users.sort((a, b) => a.mobile.compareTo(b.mobile));
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.email.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.users.sort((a, b) => b.email.compareTo(a.email));
                  } else {
                    widget.users.sort((a, b) => a.email.compareTo(b.email));
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(
              label: Text(AppStrings.date.translate(context)),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isSortAsc) {
                    widget.users.sort(
                      (a, b) => b.createdAt.compareTo(a.createdAt),
                    );
                  } else {
                    widget.users.sort(
                      (a, b) => a.createdAt.compareTo(b.createdAt),
                    );
                  }
                  _isSortAsc = !_isSortAsc;
                });
              },
            ),
            DataColumn(label: Text(AppStrings.action.translate(context))),
          ],
          rows:
              widget.users.map((user) {
                rowIndex = rowIndex + 1;
                return DataRow(
                  color:
                      rowIndex % 2 == 1
                          ? WidgetStateColor.resolveWith(
                            (states) => AppColors.background,
                          )
                          : WidgetStateColor.resolveWith(
                            (states) =>
                                AppColors.drawerBgColor!.withOpacity(0.1),
                          ),
                  cells: [
                    DataCell(Text(user.id.toString())),
                    DataCell(Text(user.name)),
                    DataCell(Text(user.mobile)),
                    DataCell(Text(user.email)),
                    DataCell(
                      Text(user.createdAt.toIso8601String().split('T').first),
                    ),
                    DataCell(
                      Row(
                        children: [
                          actionButton("View", Colors.teal, () {
                            context.go(
                              '/${user.type.toLowerCase()}/details${user.id}',
                            );
                          }),
                          const SizedBox(width: 8),
                          actionButton("Delete", Colors.red, () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              headerAnimationLoop: true,
                              animType: AnimType.scale,
                              title: 'Delete User',
                              desc:
                                  'Are you sure to delete this user from the system?',
                              btnCancelText: 'Cancel',
                              btnOkText: 'Delete',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                context.read<UsersBloc>().add(
                                  DeleteUser(id: user.id, userType: user.type),
                                );
                              },
                              buttonsBorderRadius: BorderRadius.circular(8.0),
                              buttonsTextStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              btnCancelColor: Colors.teal,
                              btnOkColor: Colors.red,
                              dismissOnBackKeyPress: true,
                              dismissOnTouchOutside: true,
                              width: 400,
                            ).show();
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
