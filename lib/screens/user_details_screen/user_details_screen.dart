import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/user_info/user_info_bloc.dart';
import 'package:transfor_admin_dashboard/screens/user_details_screen/widgets/circle_image.dart';
import 'package:transfor_admin_dashboard/global_widgets/textField.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

import '../../utilities/app_strings.dart';

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
    context.read<UserInfoBloc>().add(
      UserInfoLoadInitiate(userType: widget.userType, id: widget.id.toString()),
    );
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
          } else if (widget.userType == 'service provider') {
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
                    Switch(
                      value: state.userInfo.status == '0',
                      onChanged: (value) {
                        context.read<UserInfoBloc>().add(
                          UserStatusUpdate(
                            id: widget.id.toString(),
                            status: state.userInfo.status == '0' ? '1' : '0',
                            userType: widget.userType,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                state.userInfo.profile != null
                    ? state.userInfo.profile != '' ? Center(
                      child: circleImage(imageString: state.userInfo.profile!),
                    )
                    : Center(
                      child: CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person_pin, size: 50,),
                      ),
                    ) : 
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: textFieldDisabled(
                        labelText: AppStrings.name.translate(context),
                        textController: TextEditingController(text: state.userInfo.name),
                        isReadOnly: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: textFieldDisabled(
                        labelText: AppStrings.mobile.translate(context),
                        textController: TextEditingController(text: '${state.userInfo.ccode}${state.userInfo.mobile}'),
                        isReadOnly: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: textFieldDisabled(
                        labelText: AppStrings.email.translate(context),
                        textController: TextEditingController(text: state.userInfo.email),
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
        SizedBox(height: 20,),
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
}
