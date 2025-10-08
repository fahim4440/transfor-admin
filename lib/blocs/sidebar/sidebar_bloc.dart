import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfor_admin_dashboard/models/admin_profile.dart';

part 'sidebar_event.dart';
part 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc() : super(SidebarInitial()) {
    on<SidebarEvent>((event, emit) async {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final String? name = preferences.getString('name');
      final String? email = preferences.getString('email');
      final String? isSuperAdmin = preferences.getString('isSuperAdmin');
      AdminProfile admin = AdminProfile(
        id: '1',
        name: name!,
        email: email!,
        superadmin: isSuperAdmin!,
        status: '0',
        createdAt: DateTime.now(),
      );
      emit(SidebarLoaded(admin: admin));
    });
  }
}
