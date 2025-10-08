part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();
}

final class OrdersInitial extends OrdersState {
  @override
  List<Object> get props => [];
}

final class OrdersLoading extends OrdersState {
  @override
  List<Object?> get props => [];
}

final class OrdersLoaded extends OrdersState {
  final List<Order> orders;
  final List<Order> filteredOrders;
  const OrdersLoaded({required this.orders, required this.filteredOrders});

  @override
  List<Object?> get props => [orders, filteredOrders];
}

final class OrdersFailure extends OrdersState {
  final String message;
  const OrdersFailure({required this.message});

  @override
  List<Object?> get props => [message];
}