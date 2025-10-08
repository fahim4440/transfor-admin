part of 'payout_history_bloc.dart';

sealed class PayoutHistoryState extends Equatable {
  const PayoutHistoryState();
}

final class PayoutHistoryInitial extends PayoutHistoryState {
  @override
  List<Object> get props => [];
}

final class PayoutHistoryLoading extends PayoutHistoryState {
  @override
  List<Object?> get props => [];
}

final class PayoutHistoryLoaded extends PayoutHistoryState {
  final List<PayoutHistory> payoutHistories;
  final List<PayoutHistory> filteredPayoutHistories;
  const PayoutHistoryLoaded({
    required this.payoutHistories,
    required this.filteredPayoutHistories,
  });

  @override
  List<Object?> get props => [payoutHistories, filteredPayoutHistories];
}

final class PayoutHistoryFailure extends PayoutHistoryState {
  final String message;
  const PayoutHistoryFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
