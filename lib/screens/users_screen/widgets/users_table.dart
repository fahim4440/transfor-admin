import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:transfor_admin_dashboard/blocs/users/users_bloc.dart';
import 'package:transfor_admin_dashboard/global_widgets/app_data_grid_theme.dart';
import 'package:transfor_admin_dashboard/models/users_profile.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

class UsersTable extends StatefulWidget {
  final List<UserProfile> users;
  final bool showProviderTypeColumn;
  const UsersTable({
    super.key,
    required this.users,
    this.showProviderTypeColumn = false,
  });

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  late _UsersDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _UsersDataSource(
      users: widget.users,
      showProviderTypeColumn: widget.showProviderTypeColumn,
      onTapName: _openUser,
      onDelete: _deleteUser,
    );
  }

  @override
  void didUpdateWidget(covariant UsersTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.users != widget.users) {
      _dataSource.updateUsers(widget.users);
    }
  }

  void _openUser(UserProfile user) {
    context.go('/${user.type.toLowerCase().replaceAll(' ', '-')}/details${user.id}');
  }

  void _deleteUser(UserProfile user) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: true,
      animType: AnimType.scale,
      title: 'Delete User',
      desc: 'Are you sure to delete this user from the system?',
      btnCancelText: 'Cancel',
      btnOkText: 'Delete',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        context.read<UsersBloc>().add(
          DeleteUser(id: user.id, userType: user.type),
        );
      },
      buttonsBorderRadius: BorderRadius.circular(8.0),
      buttonsTextStyle: const TextStyle(color: Colors.white),
      btnCancelColor: Colors.teal,
      btnOkColor: Colors.red,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: true,
      width: 400,
    ).show();
  }

  List<GridColumn> _buildColumns(BuildContext context) {
    return [
      GridColumn(
        columnName: 'id',
        label: dataGridHeaderText(AppStrings.no.translate(context)),
        width: 90,
        allowFiltering: false,
      ),
      GridColumn(
        columnName: 'name',
        label: dataGridHeaderText(AppStrings.name.translate(context)),
        width: 180,
      ),
      GridColumn(
        columnName: 'mobile',
        label: dataGridHeaderText(AppStrings.mobile.translate(context)),
        width: 140,
      ),
      GridColumn(
        columnName: 'email',
        label: dataGridHeaderText(AppStrings.email.translate(context)),
        width: 220,
      ),
      GridColumn(
        columnName: 'date',
        label: dataGridHeaderText(AppStrings.date.translate(context)),
        width: 130,
      ),
      if (widget.showProviderTypeColumn)
        GridColumn(
          columnName: 'providerType',
          label: dataGridHeaderText(AppStrings.providerType.translate(context)),
          width: 160,
        ),
      GridColumn(
        columnName: 'action',
        label: dataGridHeaderText(AppStrings.action.translate(context)),
        width: 120,
        allowSorting: false,
        allowFiltering: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: appDataGridTheme,
      child: SfDataGrid(
        source: _dataSource,
        columns: _buildColumns(context),
        allowSorting: true,
        allowFiltering: true,
        allowColumnsResizing: true,
        columnResizeMode: ColumnResizeMode.onResize,
        headerRowHeight: 44,
        rowHeight: 52,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        headerGridLinesVisibility: GridLinesVisibility.horizontal,
      ),
    );
  }
}

class _UsersDataSource extends DataGridSource {
  _UsersDataSource({
    required List<UserProfile> users,
    required this.showProviderTypeColumn,
    required this.onTapName,
    required this.onDelete,
  }) {
    _users = users;
    _rows = _rowsFor(_users);
  }

  final bool showProviderTypeColumn;
  final void Function(UserProfile user) onTapName;
  final void Function(UserProfile user) onDelete;

  late List<UserProfile> _users;
  late List<DataGridRow> _rows;

  List<DataGridRow> _rowsFor(List<UserProfile> users) {
    return users.map((user) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: user.id),
        DataGridCell<String>(columnName: 'name', value: user.name),
        DataGridCell<String>(columnName: 'mobile', value: user.mobile),
        DataGridCell<String>(columnName: 'email', value: user.email),
        DataGridCell<String>(columnName: 'date', value: user.createdAt.toIso8601String().split('T').first),
        if (showProviderTypeColumn)
          DataGridCell<String>(columnName: 'providerType', value: user.providerTypeLabel),
        DataGridCell<String>(columnName: 'action', value: user.id),
      ]);
    }).toList();
  }

  void updateUsers(List<UserProfile> users) {
    _users = users;
    _rows = _rowsFor(_users);
    notifyListeners();
  }

  UserProfile _userForRow(DataGridRow row) {
    final id = row.getCells().firstWhere((cell) => cell.columnName == 'id').value as String;
    return _users.firstWhere((user) => user.id == id);
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        switch (cell.columnName) {
          case 'name':
            final user = _userForRow(row);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => onTapName(user),
                  child: Text(
                    user.name,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            );
          case 'action':
            final user = _userForRow(row);
            return Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => onDelete(user),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            );
          default:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  cell.value.toString(),
                  style: const TextStyle(color: AppColors.text),
                ),
              ),
            );
        }
      }).toList(),
    );
  }
}
