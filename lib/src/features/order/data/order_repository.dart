import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/features/order/data/data_sources/order_data_source.dart';

abstract interface class IOrderRepository {
  Future<void> postOrder(Map<MenuItem, int> items);
}

final class OrderRepository implements IOrderRepository {
  final IOrderDataSource _networkOrderDataSource;

  OrderRepository({required IOrderDataSource networkOrderDataSource})
      : _networkOrderDataSource = networkOrderDataSource;

  @override
  Future<void> postOrder(Map<MenuItem, int> items) async {
    await _networkOrderDataSource.postOrder(items: items);
  }
}
