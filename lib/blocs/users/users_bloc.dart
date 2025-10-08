import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/models/users_profile.dart';
import 'package:transfor_admin_dashboard/services/users_services.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersServices _usersServices = UsersServices();
  UsersBloc() : super(UsersInitial()) {
    on<UsersLoadingInitiate>((event, emit) async {
      emit(UsersLoading());
      try {
        final List<UserProfile>? users = await _usersServices.fetchUsers(
          event.userType,
        );
        if (users != null) {
          emit(UsersLoaded(users: users, filteredUsers: users));
        } else {
          emit(UsersFailure(message: ''));
        }
      } catch (e) {
        emit(UsersFailure(message: '"Something went wrong: $e"'));
      }
    });

    on<DeleteUser>((event, emit) async {
      emit(UsersLoading());
      try {
        final String? deleteMessage = await _usersServices.deleteUser(event.id);
        final List<UserProfile>? users = await _usersServices.fetchUsers(
          event.userType,
        );
        if (users != null && deleteMessage != null) {
          emit(UsersLoaded(users: users, filteredUsers: users));
        } else {
          emit(UsersFailure(message: ''));
        }
      } catch (e) {
        emit(UsersFailure(message: '"Something went wrong: $e"'));
      }
    });

    on<SearchUsers>((event, emit) {
      final currentState = state as UsersLoaded;
      emit(UsersLoading());
      final List<UserProfile> users = currentState.users;
      final List<UserProfile> filteredUser =
          users.where((user) {
            return user.name.toLowerCase().contains(
                  event.searchText.toLowerCase(),
                ) ||
                user.mobile.contains(event.searchText) ||
                user.email.toLowerCase().contains(
                  event.searchText.toLowerCase(),
                );
          }).toList();
      emit(UsersLoaded(users: users, filteredUsers: filteredUser));
    });
  }
}
