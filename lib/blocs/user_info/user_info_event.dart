part of 'user_info_bloc.dart';

sealed class UserInfoEvent extends Equatable {
  const UserInfoEvent();
}

final class UserInfoLoadInitiate extends UserInfoEvent {
  final String id;
  final String userType;
  const UserInfoLoadInitiate({required this.id, required this.userType});

  @override
  List<Object?> get props => [id, userType];
}

final class UserAdminConfirmation extends UserInfoEvent {
  final String id;
  final String userType;
  const UserAdminConfirmation({required this.id, required this.userType});
  
  @override
  List<Object?> get props => [id, userType];
}

final class UserStatusUpdate extends UserInfoEvent {
  final String id;
  final String status;
  final String userType;
  const UserStatusUpdate({required this.id, required this.status, required this.userType});
  
  @override
  List<Object?> get props => [id, status, userType];
}
