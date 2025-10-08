part of 'user_info_bloc.dart';

sealed class UserInfoState extends Equatable {
  const UserInfoState();
}

final class UserInfoInitial extends UserInfoState {
  @override
  List<Object> get props => [];
}

final class UserInfoLoading extends UserInfoState {
  @override
  List<Object?> get props => [];
}

final class UserInfoLoaded extends UserInfoState {
  final String id;
  final String userType;
  final UserInfo userInfo;
  final Company? company;
  final UserVehicleInfo? userVehicleInfo;
  final BankInfo? bankInfo;
  final int message;

  const UserInfoLoaded({
    required this.id,
    required this.userType,
    required this.userInfo,
    this.company,
    this.userVehicleInfo,
    this.bankInfo,
    required this.message,
  });
  @override
  List<Object?> get props => [
    id,
    userType,
    userInfo,
    company,
    userVehicleInfo,
    bankInfo,
    message,
  ];
}

final class UserInfoFailure extends UserInfoState {
  final String message;
  const UserInfoFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
