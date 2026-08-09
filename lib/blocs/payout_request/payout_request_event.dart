part of 'payout_request_bloc.dart';

sealed class PayoutRequestEvent extends Equatable {
  const PayoutRequestEvent();
}

final class PayoutRequestLoadingInitiate extends PayoutRequestEvent {
  final String userType;
  const PayoutRequestLoadingInitiate({required this.userType});

  @override
  List<Object?> get props => [userType];
}

final class SearchPayoutRequest extends PayoutRequestEvent {
  final String searchText;
  final String userType;
  const SearchPayoutRequest({required this.searchText, required this.userType});

  @override
  List<Object?> get props => [searchText, userType];
}

final class PayToUser extends PayoutRequestEvent {
  final String userId;
  final String userType;
  final String orderType;
  const PayToUser({
    required this.userId,
    required this.userType,
    required this.orderType,
  });

  @override
  List<Object?> get props => [userId, userType, orderType];
}

final class PayToProvider extends PayoutRequestEvent {
  final String providerId;
  final String userType;
  final String orderType;
  const PayToProvider({
    required this.providerId,
    required this.userType,
    required this.orderType,
  });

  @override
  List<Object?> get props => [providerId, userType, orderType];
}

final class PayToDriver extends PayoutRequestEvent {
  final String driverId;
  final String userType;
  const PayToDriver({
    required this.driverId,
    required this.userType,
  });

  @override
  List<Object?> get props => [driverId, userType];
}
