part of 'users_bloc.dart';

sealed class UsersState extends Equatable {
  const UsersState();
}

final class UsersInitial extends UsersState {
  @override
  List<Object> get props => [];
}

final class UsersLoading extends UsersState {
  @override
  List<Object?> get props => [];
}

final class UsersLoaded extends UsersState {
  final List<UserProfile> users;
  final List<UserProfile> filteredUsers;
  const UsersLoaded({required this.users, required this.filteredUsers});

  @override
  List<Object?> get props => [users, filteredUsers];
}

final class UsersFailure extends UsersState {
  final String message;
  const UsersFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
