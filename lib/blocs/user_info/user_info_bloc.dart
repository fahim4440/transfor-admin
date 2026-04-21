import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/models/bank_info.dart';
import 'package:transfor_admin_dashboard/models/company_info.dart';
import 'package:transfor_admin_dashboard/models/user_info.dart';
import 'package:transfor_admin_dashboard/models/user_vehicle_info.dart';
import 'package:transfor_admin_dashboard/services/users_services.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final UsersServices _usersServices = UsersServices();
  UserInfoBloc() : super(UserInfoInitial()) {
    on<UserInfoLoadInitiate>((event, emit) async {
      emit(UserInfoLoading());
      try {
        int message = 0;
        final UserInfo? userInfo = await _usersServices.fetchUserData(event.id);
        final Company? company = await _usersServices.fetchUserCompanyData(
          event.id,
        );
        final BankInfo? bankInfo = await _usersServices.fetchUserBankData(
          event.id,
        );
        final UserVehicleInfo? userVehicleInfo = await _usersServices
            .fetchUserVehicleData(event.id);

        if (userInfo == null) {
          message = 1;
        }
        if (company == null && event.userType == 'Service Provider') {
          message = message + 2;
        }
        if (userVehicleInfo == null && event.userType == 'Driver') {
          message = message + 4;
        }
        if (bankInfo == null) {
          message = message + 6;
        }
        if (userInfo != null) {
          emit(
            UserInfoLoaded(
              id: event.id,
              userType: event.userType,
              userInfo: userInfo,
              message: message,
              company: company,
              bankInfo: bankInfo,
              userVehicleInfo: userVehicleInfo,
            ),
          );
        } else {
          emit(UserInfoFailure(message: '1'));
        }
      } catch (e) {
        emit(UserInfoFailure(message: 'Something went wrong: $e'));
      }
    });

    on<UserStatusUpdate>((event, emit) async {
      emit(UserInfoLoading());
      try {
        int message = 0;
        final String? updateMessage = await _usersServices.updateUserStatus(
          event.id,
          event.status,
        );
        final UserInfo? userInfo = await _usersServices.fetchUserData(event.id);
        final Company? company = await _usersServices.fetchUserCompanyData(
          event.id,
        );
        final BankInfo? bankInfo = await _usersServices.fetchUserBankData(
          event.id,
        );
        final UserVehicleInfo? userVehicleInfo = await _usersServices
            .fetchUserVehicleData(event.id);

        if (userInfo == null) {
          message = 1;
        }
        if (company == null && event.userType == 'Service Provider') {
          message = message + 2;
        }
        if (userVehicleInfo == null && event.userType == 'Driver') {
          message = message + 4;
        }
        if (bankInfo == null) {
          message = message + 6;
        }
        if (userInfo != null && updateMessage != null) {
          emit(
            UserInfoLoaded(
              id: event.id,
              userType: event.userType,
              userInfo: userInfo,
              message: message,
              company: company,
              bankInfo: bankInfo,
              userVehicleInfo: userVehicleInfo,
            ),
          );
        } else {
          emit(UserInfoFailure(message: '1'));
        }
      } catch (e) {
        emit(UserInfoFailure(message: 'Something went wrong: $e'));
      }
    });

    on<UserAdminConfirmation>((event, emit) async {
      emit(UserInfoLoading());
      try {
        int message = 0;
        final String? updateMessage = await _usersServices
            .updateAdminConfirmation(event.id);
        final UserInfo? userInfo = await _usersServices.fetchUserData(event.id);
        final Company? company = await _usersServices.fetchUserCompanyData(
          event.id,
        );
        final BankInfo? bankInfo = await _usersServices.fetchUserBankData(
          event.id,
        );
        final UserVehicleInfo? userVehicleInfo = await _usersServices
            .fetchUserVehicleData(event.id);

        if (userInfo == null) {
          message = 1;
        }
        if (company == null && event.userType == 'Service Provider') {
          message = message + 2;
        }
        if (userVehicleInfo == null && event.userType == 'Driver') {
          message = message + 4;
        }
        if (bankInfo == null) {
          message = message + 6;
        }
        if (userInfo != null && updateMessage != null) {
          emit(
            UserInfoLoaded(
              id: event.id,
              userType: event.userType,
              userInfo: userInfo,
              message: message,
              company: company,
              bankInfo: bankInfo,
              userVehicleInfo: userVehicleInfo,
            ),
          );
        } else {
          emit(UserInfoFailure(message: '1'));
        }
      } catch (e) {
        emit(UserInfoFailure(message: 'Something went wrong: $e'));
      }
    });
  }
}
