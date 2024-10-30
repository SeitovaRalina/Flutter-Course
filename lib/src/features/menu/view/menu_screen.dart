import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';

import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/features/menu/view/widgets/menu_item_card.dart';
import 'package:flutter_course/src/theme/app_colors.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  int currentCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double offset = _scrollController.offset;
    int newIndex = (offset / 300).floor();

    if (newIndex != currentCategoryIndex) {
      setState(() {
        currentCategoryIndex = newIndex;
      });
      double screenWidth = MediaQuery.of(context).size.width;
      double categoryWidth = categories.length * 200;

      double categoryPosition = newIndex * 120.0 - (screenWidth - 120.0) / 2.0;

      _categoryScrollController.animateTo(
        categoryPosition.clamp(0, categoryWidth - screenWidth),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToCategory(int index) {
    setState(() {
      currentCategoryIndex = index;
    });

    double scrollTo = index * 610;
    _categoryScrollController.animateTo(
      scrollTo,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _categoryScrollController,
              child: Row(
                children: categories
                    .map((category) => _buildCategoryButton(category))
                    .toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final items = menuItems
                      .where((item) => item.categoryId == index)
                      .toList();
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCategoryTitle(category.title),
                        _buildItemGrid(items),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(MenuCategory category) {
    final categoryIndex = category.categoryId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          _scrollToCategory(categoryIndex);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: categoryIndex == currentCategoryIndex
              ? AppColors.blue
              : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        child: Text(
          category.title,
          style: TextStyle(
            color: categoryIndex == currentCategoryIndex
                ? AppColors.white
                : AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
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
