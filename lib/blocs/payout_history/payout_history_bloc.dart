import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/models/payout_history.dart';

import '../../services/payout_history_services.dart';

part 'payout_history_event.dart';
part 'payout_history_state.dart';

class PayoutHistoryBloc extends Bloc<PayoutHistoryEvent, PayoutHistoryState> {
  final PayoutHistoryServices _payoutHistoryServices = PayoutHistoryServices();
  PayoutHistoryBloc() : super(PayoutHistoryInitial()) {
    on<PayoutHistoryLoadingInitiate>((event, emit) async {
      emit(PayoutHistoryLoading());
      try {
        List<PayoutHistory>? payoutHistories = await _payoutHistoryServices.fetchPayoutHistories();
        if (payoutHistories != null) {
          emit(
            PayoutHistoryLoaded(
              payoutHistories: payoutHistories,
              filteredPayoutHistories: payoutHistories,
            ),
          );
        } else {
          emit(
            PayoutHistoryLoaded(
              payoutHistories: [],
              filteredPayoutHistories: [],
            ),
          );
        }
      } catch (e) {
        emit(PayoutHistoryFailure(message: '"Something went wrong: $e"'));
      }
    });

    on<SearchPayoutHistory>((event, emit) {
      final currentState = state as PayoutHistoryLoaded;
      emit(PayoutHistoryLoading());
      final List<PayoutHistory> payoutHistories = currentState.payoutHistories;
      final List<PayoutHistory> filteredPayoutHistories =
          payoutHistories.where((payoutHistory) {
            return payoutHistory.name.toLowerCase().contains(
                  event.searchText.toLowerCase(),
                ) ||
                payoutHistory.mobile.contains(event.searchText) ||
                payoutHistory.id.toLowerCase().contains(
                  event.searchText.toLowerCase(),
                );
          }).toList();
      emit(
        PayoutHistoryLoaded(
          payoutHistories: payoutHistories,
          filteredPayoutHistories: filteredPayoutHistories,
        ),
      );
    });
  }
}
