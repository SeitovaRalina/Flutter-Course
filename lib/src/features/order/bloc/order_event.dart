part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();
}

class OrderItemCountChanged extends OrderEvent {
  const OrderItemCountChanged(
    this.item,
    this.count,
  );
  final MenuItem item;
  final int count;

  @override
  String toString() => 'OrderItemChanged { id: ${item.id} count: $count }';

  @override
  List<Object> get props => [
        item,
        count,
      ];
}

class OrderPosted extends OrderEvent {
  const OrderPosted();

  @override
  String toString() => 'OrderPosted';

  @override
  List<Object> get props => [];
}

class OrderDeleted extends OrderEvent {
  const OrderDeleted();

  @override
  String toString() => 'OrderDeleted';

  @override
  List<Object> get props => [];
}