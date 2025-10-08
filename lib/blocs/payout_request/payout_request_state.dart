part of 'payout_request_bloc.dart';

sealed class PayoutRequestState extends Equatable {
  const PayoutRequestState();
}

final class PayoutRequestInitial extends PayoutRequestState {
  @override
  List<Object> get props => [];
}

final class PayoutRequestLoading extends PayoutRequestState {
  @override
  List<Object?> get props => [];
}

final class PayoutRequestLoaded extends PayoutRequestState {
  final List<PayoutRequest> payoutRequests;
  final List<PayoutRequest> filteredPayoutRequests;
  final String userType;
  const PayoutRequestLoaded({
    required this.payoutRequests,
    required this.filteredPayoutRequests,
    required this.userType,
  });

  @override
  List<Object?> get props => [payoutRequests, filteredPayoutRequests, userType];
}

final class PayoutRequestFailure extends PayoutRequestState {
  final String message;
  const PayoutRequestFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
