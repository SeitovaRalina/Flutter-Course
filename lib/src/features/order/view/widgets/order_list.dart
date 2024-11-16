import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/features/order/view/widgets/order_item_tile.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key, required this.items});

  final Map<MenuItem, int> items;

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final List<MenuItem> orderList = [];
  @override
  void initState() {
    super.initState();
    for (MapEntry<MenuItem, int> element in widget.items.entries) {
      for (int i = 0; i < element.value; i++) {
        orderList.add(element.key);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return OrderItemTile(
          item: orderList[index],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemCount: orderList.length,
    );
  }
}