import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/features/order/data/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final IOrderRepository _orderRepository;

  OrderBloc({required IOrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(
          const OrderState(
            status: OrderStatus.idle,
            items: <MenuItem, int>{},
            totalPrice: 0,
          ),
        ) {
    on<OrderItemCountChanged>(_onOrderItemCountChanged);
    on<OrderPosted>(_onOrderPosted);
    on<OrderDeleted>(_onOrderDeleted);
  }

  Future<void> _onOrderItemCountChanged(
    OrderItemCountChanged event,
    Emitter<OrderState> emit,
  ) async {
    Map<MenuItem, int> items = Map.from(state.items);
    final count = event.count;
    if (count == 0) {
      items.remove(event.item);
    } else {
      items[event.item] = count;
    }
    emit(
      state.copyWith(
        items: items,
        totalPrice: _pricesCounter(items),
      ),
    );
  }

  Future<void> _onOrderPosted(
    OrderPosted event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      await _orderRepository.postOrder(Map.from(state.items));
      emit(
        state.copyWith(
          status: OrderStatus.success,
          items: <MenuItem, int>{},
          totalPrice: 0,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: OrderStatus.failure,
          items: state.items,
          totalPrice: state.totalPrice,
        ),
      );
      rethrow;
    } finally {
      emit(
        state.copyWith(
          status: OrderStatus.idle,
          items: state.items,
          totalPrice: state.totalPrice,
        ),
      );
    }
  }

  Future<void> _onOrderDeleted(
    OrderDeleted event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderStatus.idle,
        items: <MenuItem, int>{},
        totalPrice: 0,
      ),
    );
  }

  int _pricesCounter(Map<MenuItem, int> items) {
    int prices = 0;
    for (var item in items.entries) {
      prices += item.value * item.key.price;
    }
    return prices;
  }
}
