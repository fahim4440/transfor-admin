import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/models/payout_request.dart';
import 'package:transfor_admin_dashboard/services/payout_request_services.dart';

part 'payout_request_event.dart';
part 'payout_request_state.dart';

class PayoutRequestBloc extends Bloc<PayoutRequestEvent, PayoutRequestState> {
  final PayoutRequestServices _payoutRequestServices = PayoutRequestServices();
  PayoutRequestBloc() : super(PayoutRequestInitial()) {
    on<PayoutRequestLoadingInitiate>((event, emit) async {
      emit(PayoutRequestLoading());
      try {
        List<PayoutRequest>? payoutRequests;
        if (event.userType == 'User') {
          payoutRequests =
              await _payoutRequestServices.fetchUserPayoutRequest();
        } else if (event.userType == 'Service Provider') {
          payoutRequests =
              await _payoutRequestServices.fetchProviderPayoutRequest();
        } else if (event.userType == 'Driver') {
          payoutRequests =
              await _payoutRequestServices.fetchDriverPayoutRequest();
        }
        if (payoutRequests != null) {
          emit(
            PayoutRequestLoaded(
              payoutRequests: payoutRequests,
              filteredPayoutRequests: payoutRequests,
              userType: event.userType,
            ),
          );
        } else {
          emit(
            PayoutRequestLoaded(
              payoutRequests: [],
              filteredPayoutRequests: [],
              userType: event.userType,
            ),
          );
        }
      } catch (e) {
        emit(PayoutRequestFailure(message: '"Something went wrong: $e"'));
      }
    });

    on<PayToUser>((event, emit) async {
      emit(PayoutRequestLoading());
      try {
        String? updateMessage = await _payoutRequestServices.payToUser(userId: event.userId, orderType: event.orderType);
        List<PayoutRequest>? payoutRequests;
        if (event.userType == 'User') {
          payoutRequests =
              await _payoutRequestServices.fetchUserPayoutRequest();
        } else if (event.userType == 'Service Provider') {
          payoutRequests =
              await _payoutRequestServices.fetchProviderPayoutRequest();
        } else if (event.userType == 'Driver') {
          payoutRequests =
              await _payoutRequestServices.fetchDriverPayoutRequest();
        }
        if (payoutRequests != null && updateMessage != null) {
          emit(
            PayoutRequestLoaded(
              payoutRequests: payoutRequests,
              filteredPayoutRequests: payoutRequests,
              userType: event.userType,
            ),
          );
        } else {
          emit(PayoutRequestFailure(message: ''));
        }
      } catch (e) {
        emit(PayoutRequestFailure(message: '"Something went wrong: $e"'));
      }
    });

    on<PayToProvider>((event, emit) async {
      emit(PayoutRequestLoading());
      try {
        String? updateMessage = await _payoutRequestServices.payToProvider(orderId: event.orderId, orderType: event.orderType);
        List<PayoutRequest>? payoutRequests;
        if (event.userType == 'User') {
          payoutRequests =
              await _payoutRequestServices.fetchUserPayoutRequest();
        } else if (event.userType == 'Service Provider') {
          payoutRequests =
              await _payoutRequestServices.fetchProviderPayoutRequest();
        } else if (event.userType == 'Driver') {
          payoutRequests =
              await _payoutRequestServices.fetchDriverPayoutRequest();
        }
        if (payoutRequests != null && updateMessage != null) {
          emit(
            PayoutRequestLoaded(
              payoutRequests: payoutRequests,
              filteredPayoutRequests: payoutRequests,
              userType: event.userType,
            ),
          );
        } else {
          emit(PayoutRequestFailure(message: ''));
        }
      } catch (e) {
        emit(PayoutRequestFailure(message: '"Something went wrong: $e"'));
      }
    });

    on<PayToDriver>((event, emit) async {
      emit(PayoutRequestLoading());
      try {
        String? updateMessage = await _payoutRequestServices.payToDriver(driverId: event.driverId);
        List<PayoutRequest>? payoutRequests;
        if (event.userType == 'User') {
          payoutRequests =
              await _payoutRequestServices.fetchUserPayoutRequest();
        } else if (event.userType == 'Service Provider') {
          payoutRequests =
              await _payoutRequestServices.fetchProviderPayoutRequest();
        } else if (event.userType == 'Driver') {
          payoutRequests =
              await _payoutRequestServices.fetchDriverPayoutRequest();
        }
        if (payoutRequests != null && updateMessage != null) {
          emit(
            PayoutRequestLoaded(
              payoutRequests: payoutRequests,
              filteredPayoutRequests: payoutRequests,
              userType: event.userType,
            ),
          );
        } else {
          emit(PayoutRequestFailure(message: ''));
        }
      } catch (e) {
        emit(PayoutRequestFailure(message: '"Something went wrong: $e"'));
      }
    });

    on<SearchPayoutRequest>((event, emit) {
      final currentState = state as PayoutRequestLoaded;
      emit(PayoutRequestLoading());
      final List<PayoutRequest> payoutRequests = currentState.payoutRequests;
      final List<PayoutRequest> filteredPayoutRequests =
          payoutRequests.where((payoutRequest) {
            return payoutRequest.name.toLowerCase().contains(
                  event.searchText.toLowerCase(),
                ) ||
                payoutRequest.mobile.contains(event.searchText) ||
                payoutRequest.id.toLowerCase().contains(
                  event.searchText.toLowerCase(),
                );
          }).toList();
      emit(
        PayoutRequestLoaded(
          payoutRequests: payoutRequests,
          filteredPayoutRequests: filteredPayoutRequests,
          userType: event.userType,
        ),
      );
    });
  }
}
