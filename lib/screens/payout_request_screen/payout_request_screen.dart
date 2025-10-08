import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/payout_request/payout_request_bloc.dart';
import 'package:transfor_admin_dashboard/screens/payout_request_screen/widgets/dropdown_button.dart';
import 'package:transfor_admin_dashboard/screens/payout_request_screen/widgets/payout_requests_table.dart';

import '../../global_widgets/seachbox.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/dimensions.dart';

class PayoutRequestScreen extends StatefulWidget {
  final String userType;
  const PayoutRequestScreen({super.key, required this.userType});

  @override
  State<PayoutRequestScreen> createState() => _PayoutRequestScreenState();
}

class _PayoutRequestScreenState extends State<PayoutRequestScreen> {
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
    context.read<PayoutRequestBloc>().add(
      PayoutRequestLoadingInitiate(userType: widget.userType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayoutRequestBloc, PayoutRequestState>(
      listener: (context, state) {
        if (state is PayoutRequestFailure) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        if (state is PayoutRequestLoaded) {
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SearchBox(
                        searchType: 'Payout Request',
                        userType: widget.userType,
                      ),
                    ),
                    SizedBox(width: AppDimensions.biggerSpacing),
                    Expanded(
                      child: dropdownButton(
                        selectedCategory: state.userType,
                        fetchPayoutRequestByCategory: (userType) {
                          context.read<PayoutRequestBloc>().add(
                            PayoutRequestLoadingInitiate(userType: userType),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                state.filteredPayoutRequests.isEmpty
                    ? SizedBox.shrink()
                    : Expanded(
                      child: PayoutRequestsTable(
                        payoutRequests: state.filteredPayoutRequests, userType: state.userType,
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
