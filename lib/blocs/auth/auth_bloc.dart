import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfor_admin_dashboard/services/auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final String message = await authService.login(event.email, event.password);
        if (message == 'successfull') {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure(message));
        }
      } catch (e) {
        emit(AuthFailure("Something went wrong: $e"));
      }
    });

    on<CheckLoginStatus>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final bool? isLoggedIn = prefs.getBool('isLoggedIn');
      if (isLoggedIn != null && isLoggedIn) {
        emit(AuthSuccess());
      } else {
        emit(AuthInitial());
      }
    });
  }
}
