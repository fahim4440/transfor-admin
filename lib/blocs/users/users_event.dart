part of 'users_bloc.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();
}

final class UsersLoadingInitiate extends UsersEvent {
  final String userType;
  const UsersLoadingInitiate({required this.userType});
  @override
  List<Object?> get props => [userType];
}

final class SearchUsers extends UsersEvent {
  final String searchText;
  const SearchUsers({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}

final class DeleteUser extends UsersEvent {
  final String id;
  final String userType;
  const DeleteUser({required this.id, required this.userType});

  @override
  List<Object?> get props => [id, userType];
}
