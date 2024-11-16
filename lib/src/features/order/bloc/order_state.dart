part of 'order_bloc.dart';

enum OrderStatus {
  idle,
  loading,
  success,
  failure,
}

final class OrderState extends Equatable {
  final OrderStatus status;
  final Map<MenuItem, int> items;
  final int totalPrice;

  const OrderState({
    required this.status,
    required this.items,
    required this.totalPrice,
  });

  OrderState copyWith({
    OrderStatus? status,
    Map<MenuItem, int>? items,
    int? totalPrice,
  }) {
    return OrderState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  String toString() {
    return 'OrderState { status: $status, items: $items, totalPrice: $totalPrice }';
  }

  @override
  List<Object> get props => [
        status,
        items,
        totalPrice,
      ];
}
