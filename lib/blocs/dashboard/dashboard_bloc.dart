import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/models/dashboard.dart';
import 'package:transfor_admin_dashboard/services/dashboard_services.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardServices dashboardServices = DashboardServices();
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardInitiate>((event, emit) async {
      emit(DashboardLoading());
      try {
        final AllCount? allCount = await dashboardServices.fetchAllCount();
        if (allCount != null) {
          emit(DashboardLoaded(allCount: allCount));
        } else {
          emit(DashboardFailure(errorMessage: ''));
        }
      } catch (e) {
        emit(DashboardFailure(errorMessage: '"Something went wrong: $e"'));
      }
    });
  }
}
