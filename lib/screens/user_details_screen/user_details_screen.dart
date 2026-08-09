import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transfor_admin_dashboard/blocs/user_info/user_info_bloc.dart';
import 'package:transfor_admin_dashboard/global_widgets/add_button.dart';
import 'package:transfor_admin_dashboard/screens/user_details_screen/widgets/circle_image.dart';
import 'package:transfor_admin_dashboard/global_widgets/textField.dart';
import 'package:transfor_admin_dashboard/models/customer_order.dart';
import 'package:transfor_admin_dashboard/models/wallet_transaction.dart';
import 'package:transfor_admin_dashboard/services/pdf/order_history_pdf_generator.dart';
import 'package:transfor_admin_dashboard/services/pdf/pdf_opener.dart';
import 'package:transfor_admin_dashboard/services/users_services.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

import '../../utilities/app_strings.dart';

typedef CustomerPdfInfo = ({String name, String mobile, String userTypeLabel});

class UserDetailsScreen extends StatefulWidget {
  final int id;
  final String userType;
  const UserDetailsScreen({
    super.key,
    required this.id,
    required this.userType,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late UsersServices usersServices;
  List<CustomerOrder>? completedOrders;
  List<CustomerOrder>? cancelledOrders;
  List<WalletTransaction>? transactions;
  WalletSummary? walletSummary;
  bool isLoadingOrders = true;
  bool isLoadingWallet = true;
  bool isGeneratingCompletedPdf = false;
  bool isGeneratingCancelledPdf = false;

  DateTime? orderFilterFrom;
  DateTime? orderFilterTo;
  int? completedOrdersTotal;
  int? cancelledOrdersTotal;

  Future<void> loadCustomerData() async {
    final id = widget.id.toString();
    final userType = widget.userType;

    try {
      await _loadResolvedOrders();
    } catch (e) {
      if (mounted) setState(() => isLoadingOrders = false);
    }

    try {
      final walletData = await usersServices.getProfileWalletSummary(id, userType);
      final transactionsData = await usersServices.getProfileWalletTransactions(id, userType, limit: 5, offset: 0);
      if (mounted) {
        setState(() {
          walletSummary = walletData;
          transactions = transactionsData;
          isLoadingWallet = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingWallet = false);
    }
  }

  Future<void> _loadResolvedOrders({String? dateFrom, String? dateTo, int limit = 5}) async {
    final id = widget.id.toString();
    final userType = widget.userType;
    final completedResponse = await usersServices.getProfileOrders(
      id,
      userType,
      limit: limit,
      offset: 0,
      dateFrom: dateFrom,
      dateTo: dateTo,
      status: '0',
    );
    final cancelledResponse = await usersServices.getProfileOrders(
      id,
      userType,
      limit: limit,
      offset: 0,
      dateFrom: dateFrom,
      dateTo: dateTo,
      status: '-1',
    );
    if (mounted) {
      setState(() {
        completedOrders = completedResponse?.orders;
        cancelledOrders = cancelledResponse?.orders;
        completedOrdersTotal = completedResponse?.totalOrders;
        cancelledOrdersTotal = cancelledResponse?.totalOrders;
        isLoadingOrders = false;
      });
    }
  }

  Future<void> pickOrderFilterDate({required bool isFrom}) async {
    final initial = (isFrom ? orderFilterFrom : orderFilterTo) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        orderFilterFrom = picked;
      } else {
        orderFilterTo = picked;
      }
    });
  }

  Future<void> applyOrderDateFilter() async {
    if (orderFilterFrom == null || orderFilterTo == null) return;
    final dateFormat = DateFormat('yyyy-MM-dd');
    final from = dateFormat.format(orderFilterFrom!);
    final to = dateFormat.format(orderFilterTo!);
    setState(() => isLoadingOrders = true);
    try {
      // limit: 0 = no limit, filtered view shows every matching order
      await _loadResolvedOrders(dateFrom: from, dateTo: to, limit: 0);
    } catch (e) {
      if (mounted) setState(() => isLoadingOrders = false);
    }
  }

  Future<void> clearOrderDateFilter() async {
    setState(() {
      orderFilterFrom = null;
      orderFilterTo = null;
      completedOrdersTotal = null;
      cancelledOrdersTotal = null;
      isLoadingOrders = true;
    });
    await loadCustomerData();
  }
  // void _showError(String message) {
  //   String errorMessage = '';
  //   if (message == '1') {
  //     errorMessage = AppStrings.userIsNotFound.translate(context);
  //   } else {
  //     errorMessage = message;
  //   }
  //   AwesomeDialog(
  //     context: context,
  //     dialogType: DialogType.error,
  //     title: AppStrings.loginFailed.translate(context),
  //     desc: errorMessage,
  //     btnOkOnPress: () {},
  //     width: 400,
  //   ).show();
  // }

  // void _showPartialError(int message) {
  //   String errorMessage = '';
  //   if (message == 1) {
  //     errorMessage = AppStrings.userIsNotFound.translate(context);
  //   } else if (message == 2) {
  //     errorMessage = AppStrings.companyIsNotFound.translate(context);
  //   } else if (message == 3) {
  //     errorMessage = AppStrings.userAndCompanyAreNotFound.translate(context);
  //   } else if (message == 4) {
  //     errorMessage = AppStrings.vehicleIsNotFound.translate(context);
  //   } else if (message == 5) {
  //     errorMessage = AppStrings.userAndVehicleAreNotFound.translate(context);
  //   } else if (message == 6) {
  //     errorMessage = AppStrings.bankInfoIsNotFound.translate(context);
  //   } else if (message == 7) {
  //     errorMessage = AppStrings.userAndBankInfoAreNotFound.translate(context);
  //   } else if (message == 8) {
  //     errorMessage = AppStrings.companyAndBankInfoAreNotFound.translate(
  //       context,
  //     );
  //   } else if (message == 9) {
  //     errorMessage = AppStrings.userAndcompanyAndBankInfoAreNotFound.translate(
  //       context,
  //     );
  //   } else if (message == 10) {
  //     errorMessage = AppStrings.vehicleAndBankInfoAreNotFound.translate(
  //       context,
  //     );
  //   } else if (message == 11) {
  //     errorMessage = AppStrings.userAndVehicleAndBankInfoAreNotFound.translate(
  //       context,
  //     );
  //   }
  //   AwesomeDialog(
  //     context: context,
  //     dialogType: DialogType.error,
  //     title: AppStrings.loginFailed.translate(context),
  //     desc: errorMessage,
  //     btnOkOnPress: () {},
  //     width: 400,
  //   ).show();
  // }

  @override
  void initState() {
    super.initState();
    usersServices = UsersServices();
    context.read<UserInfoBloc>().add(
      UserInfoLoadInitiate(userType: widget.userType, id: widget.id.toString()),
    );
    loadCustomerData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserInfoFailure) {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   _showError(state.message);
          // });
          return const SizedBox.shrink();
        } else if (state is UserInfoLoaded) {
          String userTypeDetails = '';
          if (widget.userType == 'Individual') {
            userTypeDetails = AppStrings.userDetails.translate(context);
          } else if (widget.userType == 'Service Provider') {
            userTypeDetails = AppStrings.providerDetails.translate(context);
          } else if (widget.userType == 'Driver') {
            userTypeDetails = AppStrings.driverDetails.translate(context);
          }
          // state.message != 0
          //     ? WidgetsBinding.instance.addPostFrameCallback((_) {
          //       _showPartialError(state.message);
          //     })
          //     : WidgetsBinding.instance.addPostFrameCallback((_) {});
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userTypeDetails,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    state.userInfo.adminConfirmation == '0'
                        ? Switch(
                          value: state.userInfo.status == '0',
                          onChanged: (value) {
                            context.read<UserInfoBloc>().add(
                              UserStatusUpdate(
                                id: widget.id.toString(),
                                status:
                                    state.userInfo.status == '0' ? '1' : '0',
                                userType: widget.userType,
                              ),
                            );
                          },
                        )
                        : SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 20),
                state.userInfo.profile != null
                    ? state.userInfo.profile != ''
                        ? Center(
                          child: circleImage(
                            imageString: state.userInfo.profile!,
                          ),
                        )
                        : Center(
                          child: CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person_pin, size: 50),
                          ),
                        )
                    : const SizedBox(height: 20),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: textFieldDisabled(
                        labelText: AppStrings.name.translate(context),
                        textController: TextEditingController(
                          text: state.userInfo.name,
                        ),
                        isReadOnly: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: textFieldDisabled(
                        labelText: AppStrings.mobile.translate(context),
                        textController: TextEditingController(
                          text:
                              '${state.userInfo.ccode}${state.userInfo.mobile}',
                        ),
                        isReadOnly: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: textFieldDisabled(
                        labelText: AppStrings.email.translate(context),
                        textController: TextEditingController(
                          text: state.userInfo.email,
                        ),
                        isReadOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                state.userVehicleInfo == null
                    ? SizedBox.shrink()
                    : vehicleSection(
                      vehiclePhtoto: state.userVehicleInfo!.vImage,
                      vehicleCertificate: state.userVehicleInfo!.truckCerty,
                      licenseFront: state.userVehicleInfo!.lFront,
                      licenseBack: state.userVehicleInfo!.lBack,
                      smallType: state.userVehicleInfo!.vsSmall == '0',
                      mediumType: state.userVehicleInfo!.vsMedium == '0',
                      largeType: state.userVehicleInfo!.vsBig == '0',
                      transportMaterials: state.userVehicleInfo!.transportData,
                    ),
                state.company == null
                    ? SizedBox.shrink()
                    : providerSection(
                      companyProfile: state.company!.companyLogo,
                      companyName: state.company!.companyName,
                      companyDescription: state.company!.companyDesc,
                    ),
                state.bankInfo == null
                    ? SizedBox.shrink()
                    : bankInfoSection(
                      bankImage: state.bankInfo!.ibanImage,
                      cardImage: state.bankInfo!.crImage,
                      accountNumber: state.bankInfo!.ibanNo,
                    ),
                buildWalletSection(),
                buildOrdersSection((
                  name: state.userInfo.name,
                  mobile: '${state.userInfo.ccode}${state.userInfo.mobile}',
                  userTypeLabel: widget.userType == 'Individual'
                      ? 'Customer'
                      : widget.userType == 'Service Provider'
                          ? (state.company?.providerTypeLabel ?? 'Product & Delivery Provider')
                          : (state.userInfo.isCompanyDriver ? 'Company Driver' : 'Single Driver'),
                )),
                Center(
                  child:
                      state.userInfo.adminConfirmation == '1'
                          ? addButton(
                            AppStrings.confirm.translate(context),
                            () {
                              context.read<UserInfoBloc>().add(
                                UserAdminConfirmation(
                                  id: widget.id.toString(),
                                  userType: widget.userType,
                                ),
                              );
                            },
                          )
                          : SizedBox.shrink(),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Column bankInfoSection({
    required String bankImage,
    required String cardImage,
    required String accountNumber,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.bankDetails.translate(context),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(AppStrings.ibanNumber.translate(context)),
                SizedBox(height: AppDimensions.smallPadding),
                circleImage(imageString: bankImage),
              ],
            ),
            // const SizedBox(width: 20,),
            Column(
              children: [
                Text(AppStrings.corporateRegistration.translate(context)),
                SizedBox(height: AppDimensions.smallPadding),
                circleImage(imageString: cardImage),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        textFieldDisabled(
          labelText: AppStrings.ibanNumber.translate(context),
          textController: TextEditingController(text: accountNumber),
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Column providerSection({
    required String? companyProfile,
    required String companyName,
    required String companyDescription,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.companyDetails.translate(context),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        companyProfile != null
            ? Center(child: circleImage(imageString: companyProfile))
            : Center(
              child: CircleAvatar(radius: 50, child: Icon(Icons.person_pin)),
            ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: textFieldDisabled(
                labelText: AppStrings.companyName.translate(context),
                textController: TextEditingController(text: companyName),
                isReadOnly: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: textFieldDisabled(
                labelText: AppStrings.companyDescription.translate(context),
                textController: TextEditingController(text: companyDescription),
                isReadOnly: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Column vehicleSection({
    required String vehiclePhtoto,
    required String vehicleCertificate,
    required String licenseFront,
    required String licenseBack,
    required bool smallType,
    required bool mediumType,
    required bool largeType,
    required String transportMaterials,
  }) {
    return Column(
      children: [
        Text(
          AppStrings.vehicleDetails.translate(context),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          AppStrings.vehicleDocumemts.translate(context),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(AppStrings.vehiclePhoto.translate(context)),
                SizedBox(height: AppDimensions.smallPadding),
                circleImage(imageString: vehiclePhtoto),
              ],
            ),
            Column(
              children: [
                Text(AppStrings.vehicleCertificate.translate(context)),
                SizedBox(height: AppDimensions.smallPadding),
                circleImage(imageString: vehicleCertificate),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(AppStrings.licenseFront.translate(context)),
                SizedBox(height: AppDimensions.smallPadding),
                circleImage(imageString: licenseFront),
              ],
            ),
            Column(
              children: [
                Text(AppStrings.licenseBack.translate(context)),
                SizedBox(height: AppDimensions.smallPadding),
                circleImage(imageString: licenseBack),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          AppStrings.vehicleType.translate(context),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            FilterChip(
              label: Text(AppStrings.small.translate(context)),
              selected: smallType,
              onSelected: (_) {},
            ),
            const SizedBox(width: 10),
            FilterChip(
              label: Text(AppStrings.medium.translate(context)),
              selected: mediumType,
              onSelected: (_) {},
            ),
            const SizedBox(width: 10),
            FilterChip(
              label: Text(AppStrings.large.translate(context)),
              selected: largeType,
              onSelected: (_) {},
            ),
          ],
        ),
        const SizedBox(height: 20),
        textFieldDisabled(
          labelText: AppStrings.transportMaterials.translate(context),
          textController: TextEditingController(text: transportMaterials),
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildWalletSection() {
    final isEarningsView = widget.userType == 'Driver' || widget.userType == 'Service Provider';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          isEarningsView ? 'Earnings & Payouts' : 'Wallet Summary',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        if (isLoadingWallet)
          Center(child: CircularProgressIndicator())
        else if (walletSummary != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: textFieldDisabled(
                      labelText: isEarningsView ? 'Pending Payout' : 'Wallet Balance',
                      textController: TextEditingController(
                        text: '⃁ ${walletSummary!.balance.toStringAsFixed(2)}',
                      ),
                      isReadOnly: true,
                      style: const TextStyle(fontFamilyFallback: ['SaudiRiyal']),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: textFieldDisabled(
                      labelText: 'Total Transactions',
                      textController: TextEditingController(
                        text: walletSummary!.totalTransactions.toString(),
                      ),
                      isReadOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (transactions != null && transactions!.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Balance')),
                    ],
                    rows: transactions!.map((tx) {
                      return DataRow(cells: [
                        DataCell(Text(tx.type)),
                        DataCell(Text('⃁ ${tx.amount.toStringAsFixed(2)}', style: const TextStyle(fontFamilyFallback: ['SaudiRiyal']))),
                        DataCell(Text(tx.description)),
                        DataCell(Text(tx.date.toString().split(' ').first)),
                        DataCell(Text('⃁ ${tx.balanceAfter.toStringAsFixed(2)}', style: const TextStyle(fontFamilyFallback: ['SaudiRiyal']))),
                      ]);
                    }).toList(),
                  ),
                )
              else
                Center(child: Text('No transactions found')),
              const SizedBox(height: 10),
              if (walletSummary!.totalTransactions > 5)
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement show all transactions
                    },
                    child: Text('Show All Transactions'),
                  ),
                ),
            ],
          )
        else
          Center(child: Text('No wallet data available')),
      ],
    );
  }

  Widget buildOrdersSection(CustomerPdfInfo customerInfo) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final isFilterReady = orderFilterFrom != null && orderFilterTo != null;
    final isFilterValid = !isFilterReady || !orderFilterFrom!.isAfter(orderFilterTo!);
    final isFilterApplied = completedOrdersTotal != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'Order History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton(
              onPressed: () => pickOrderFilterDate(isFrom: true),
              child: Text(
                orderFilterFrom == null ? 'From date' : dateFormat.format(orderFilterFrom!),
              ),
            ),
            OutlinedButton(
              onPressed: () => pickOrderFilterDate(isFrom: false),
              child: Text(
                orderFilterTo == null ? 'To date' : dateFormat.format(orderFilterTo!),
              ),
            ),
            ElevatedButton(
              onPressed: isFilterReady && isFilterValid ? applyOrderDateFilter : null,
              child: Text('Apply'),
            ),
            if (isFilterApplied)
              TextButton(
                onPressed: clearOrderDateFilter,
                child: Text('Clear'),
              ),
          ],
        ),
        if (isFilterReady && !isFilterValid)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '"From date" must be before "To date"',
              style: TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 20),
        if (isLoadingOrders)
          Center(child: CircularProgressIndicator())
        else
          buildResolvedOrdersView(customerInfo),
      ],
    );
  }

  Future<void> _printOrderHistoryPdf({
    required List<CustomerOrder> orders,
    required CustomerPdfInfo customerInfo,
    required String sectionLabel,
    required bool isCompleted,
  }) async {
    setState(() {
      if (isCompleted) {
        isGeneratingCompletedPdf = true;
      } else {
        isGeneratingCancelledPdf = true;
      }
    });
    try {
      final bytes = await generateOrderHistoryPdf(
        orders: orders,
        userName: customerInfo.name,
        mobile: customerInfo.mobile,
        userTypeLabel: customerInfo.userTypeLabel,
        sectionLabel: sectionLabel,
        filterFrom: orderFilterFrom,
        filterTo: orderFilterTo,
      );
      final fileName = '${sectionLabel.toLowerCase().replaceAll(' ', '_')}_${widget.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await openPdf(bytes, fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not generate PDF: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          if (isCompleted) {
            isGeneratingCompletedPdf = false;
          } else {
            isGeneratingCancelledPdf = false;
          }
        });
      }
    }
  }

  Widget buildResolvedOrdersView(CustomerPdfInfo customerInfo) {
    final completed = completedOrders ?? [];
    final cancelled = cancelledOrders ?? [];
    final completedCount = completedOrdersTotal ?? completed.length;
    final cancelledCount = cancelledOrdersTotal ?? cancelled.length;
    final resolvedTotal = completedCount + cancelledCount;

    if (resolvedTotal == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(AppStrings.noResolvedOrders.translate(context)),
        ),
      );
    }

    final completedPct = completedCount / resolvedTotal;
    final cancelledPct = 1 - completedPct;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildResolvedRatioBar(completedPct, cancelledPct, completedCount, cancelledCount),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final completedPanel = buildOrderPanel(
              title: AppStrings.completedOrders.translate(context),
              color: AppColors.green,
              count: completedCount,
              orders: completed,
              isGeneratingPdf: isGeneratingCompletedPdf,
              onPrintPdf: () => _printOrderHistoryPdf(
                orders: completed,
                customerInfo: customerInfo,
                sectionLabel: AppStrings.completedOrders.translate(context),
                isCompleted: true,
              ),
            );
            final cancelledPanel = buildOrderPanel(
              title: AppStrings.cancelledOrders.translate(context),
              color: AppColors.error,
              count: cancelledCount,
              orders: cancelled,
              isGeneratingPdf: isGeneratingCancelledPdf,
              onPrintPdf: () => _printOrderHistoryPdf(
                orders: cancelled,
                customerInfo: customerInfo,
                sectionLabel: AppStrings.cancelledOrders.translate(context),
                isCompleted: false,
              ),
            );
            if (constraints.maxWidth < 700) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [completedPanel, const SizedBox(height: 24), cancelledPanel],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: completedPanel),
                const SizedBox(width: 24),
                Expanded(child: cancelledPanel),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget buildResolvedRatioBar(double completedPct, double cancelledPct, int completedCount, int cancelledCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 22,
            child: Row(
              children: [
                if (completedPct > 0)
                  Expanded(
                    flex: (completedPct * 1000).round().clamp(1, 1000),
                    child: Container(color: AppColors.green),
                  ),
                if (cancelledPct > 0)
                  Expanded(
                    flex: (cancelledPct * 1000).round().clamp(1, 1000),
                    child: Container(color: AppColors.error),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: [
            buildRatioLegendEntry(
              AppColors.green,
              '${AppStrings.completedOrders.translate(context)}: ${(completedPct * 100).toStringAsFixed(1)}% ($completedCount)',
            ),
            buildRatioLegendEntry(
              AppColors.error,
              '${AppStrings.cancelledOrders.translate(context)}: ${(cancelledPct * 100).toStringAsFixed(1)}% ($cancelledCount)',
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRatioLegendEntry(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }

  Widget buildOrderPanel({
    required String title,
    required Color color,
    required int count,
    required List<CustomerOrder> orders,
    required bool isGeneratingPdf,
    required VoidCallback onPrintPdf,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text('$title ($count)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(
              tooltip: 'Print PDF',
              onPressed: isGeneratingPdf || orders.isEmpty ? null : onPrintPdf,
              icon: isGeneratingPdf
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (orders.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('No orders found'),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Order #')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Date')),
              ],
              rows: orders.map((order) {
                return DataRow(cells: [
                  DataCell(Text(order.orderNumber)),
                  DataCell(Text('⃁ ${order.amount.toStringAsFixed(2)}', style: const TextStyle(fontFamilyFallback: ['SaudiRiyal']))),
                  DataCell(Text(order.type)),
                  DataCell(Text(order.date.toString().split(' ').first)),
                ]);
              }).toList(),
            ),
          ),
      ],
    );
  }
}
