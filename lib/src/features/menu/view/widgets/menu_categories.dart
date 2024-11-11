import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/features/menu/view/widgets/menu_item_card.dart';

class MenuCategories extends StatelessWidget {
  final MenuCategory category;
  final List<MenuItem> items;

  const MenuCategories({
    Key? key,
    required this.category,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCategoryTitle(context, category.name),
          _buildItemGrid(items),
        ],
      ),
    );
  }

  Widget _buildCategoryTitle(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        name,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  Widget _buildItemGrid(List<MenuItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 210,
      ),
      itemCount: items.length,
      itemBuilder: (context, itemIndex) {
        return MenuItemCard(item: items[itemIndex]);
      },
    );
  }
}
