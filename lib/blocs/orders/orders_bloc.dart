import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/models/order.dart';
import 'package:transfor_admin_dashboard/services/orders_services.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersServices _ordersServices = OrdersServices();
  OrdersBloc() : super(OrdersInitial()) {
    on<OrdersLoadingInitiate>((event, emit) async {
      emit(OrdersLoading());
      try {
        List<Order>? orders = [];
        List<Order>? totalOrders;
        if (event.ordersCompleteType == 'orderPlaced' ||
            event.ordersCompleteType == 'inProgress') {
          totalOrders = await _ordersServices.fetchCurrentOrders('TRANS');
          if (totalOrders != null) {
            final wantedStatus =
                event.ordersCompleteType == 'orderPlaced' ? 'Order Placed' : 'Processing';
            for (Order order in totalOrders) {
              if (order.status == wantedStatus) {
                orders.add(order);
              }
            }
          }
        }
        if (event.ordersCompleteType == 'delivered') {
          totalOrders = await _ordersServices.fetchCompletedCancelledOrders(
            'TRANS',
            '0',
          );
          if (totalOrders != null) {
            orders = totalOrders;
          }
        }
        if (event.ordersCompleteType == 'cancelled') {
          totalOrders = await _ordersServices.fetchCompletedCancelledOrders(
            'TRANS',
            '-1',
          );
          if (totalOrders != null) {
            orders = totalOrders;
          }
        }
        if (totalOrders != null) {
          emit(OrdersLoaded(orders: orders, filteredOrders: orders));
        } else {
          emit(OrdersFailure(message: ''));
        }
      } catch (e) {
        emit(OrdersFailure(message: '"Something went wrong: $e"'));
      }
    });

    on<SearchOrders>((event, emit) {
      final currentState = state as OrdersLoaded;
      emit(OrdersLoading());
      final List<Order> orders = currentState.orders;
      final List<Order> filteredOrders =
          orders.where((order) {
            return order.orderNumber.toLowerCase().contains(
                  event.searchText.toLowerCase(),
                ) ||
                order.userName.toLowerCase().contains(event.searchText) ||
                order.userEmail.toLowerCase().contains(
                  event.searchText.toLowerCase(),
                ) ||
                order.userMobile.toLowerCase().contains(event.searchText);
          }).toList();
      emit(OrdersLoaded(orders: orders, filteredOrders: filteredOrders));
    });
  }
}
