part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();
}

final class OrdersLoadingInitiate extends OrdersEvent {
  final String ordersCompleteType;
  const OrdersLoadingInitiate({required this.ordersCompleteType});

  @override
  List<Object?> get props => [ordersCompleteType];
}

final class SearchOrders extends OrdersEvent {
  final String searchText;
  const SearchOrders({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}
