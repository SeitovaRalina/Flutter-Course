import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/view/widgets/menu_categories.dart';
import 'package:flutter_course/src/theme/app_colors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ItemScrollController _categoryScrollController = ItemScrollController();
  final ItemScrollController _menuScrollController = ItemScrollController();
  final ItemPositionsListener _itemListener = ItemPositionsListener.create();
  int currentCategoryIndex = 0;

  @override
  void initState() {
    super.initState();

    _itemListener.itemPositions.addListener(() {
      final positions = _itemListener.itemPositions.value;

      if (positions.isNotEmpty) {
        final firstVisibleIndex = positions.first.index;
        final lastVisibleIndex = positions.last.index;

        if (lastVisibleIndex == categories.length - 1 &&
            positions.last.itemTrailingEdge == 1) {
          _setCurrentCategoryIndex(lastVisibleIndex);
        } else {
          if (currentCategoryIndex != firstVisibleIndex) {
            _setCurrentCategoryIndex(firstVisibleIndex);
            _scrollHorizontalToCategory(firstVisibleIndex);
          }
        }
      }
    });
  }

  void _setCurrentCategoryIndex(int index) {
    setState(() {
      currentCategoryIndex = index;
    });
  }

  void _scrollVerticalToCategory(int index) {
    _menuScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollHorizontalToCategory(int index) {
    _categoryScrollController.scrollTo(
      index: index,
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
            SizedBox(
              height: 40,
              child: ScrollablePositionedList.builder(
                itemScrollController: _categoryScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryButton(categories[index]);
                },
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: _menuScrollController,
                itemPositionsListener: _itemListener,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return MenuCategories(categoryIndex: index);
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
      child: TextButton(
        onPressed: () {
          _setCurrentCategoryIndex(categoryIndex);
          _scrollVerticalToCategory(categoryIndex);
          _scrollHorizontalToCategory(categoryIndex);
        },
        style: TextButton.styleFrom(
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
}
