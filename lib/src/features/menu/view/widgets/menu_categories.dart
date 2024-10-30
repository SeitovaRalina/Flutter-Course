import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/features/menu/view/widgets/menu_item_card.dart';

class MenuCategories extends StatelessWidget {
  final int categoryIndex;

  const MenuCategories({
    Key? key,
    required this.categoryIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = categories[categoryIndex];
    final items =
        menuItems.where((item) => item.categoryId == categoryIndex).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCategoryTitle(context, category.title),
          _buildItemGrid(items),
        ],
      ),
    );
  }

  Widget _buildCategoryTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
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
