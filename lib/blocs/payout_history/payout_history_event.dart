part of 'payout_history_bloc.dart';

sealed class PayoutHistoryEvent extends Equatable {
  const PayoutHistoryEvent();
}

final class PayoutHistoryLoadingInitiate extends PayoutHistoryEvent {
  const PayoutHistoryLoadingInitiate();

  @override
  List<Object?> get props => [];
}

final class SearchPayoutHistory extends PayoutHistoryEvent {
  final String searchText;
  const SearchPayoutHistory({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}