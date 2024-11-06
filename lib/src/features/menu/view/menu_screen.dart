import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/view/widgets/menu_categories.dart';
import 'package:flutter_course/src/theme/app_colors.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _menuScrollController = ScrollController();
  final List<GlobalKey> categoryKeys = [];
  int currentCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    for (var _ in categories) {
      categoryKeys.add(GlobalKey());
    }
    _menuScrollController.addListener(_menuScrollListener);
  }

  @override
  void dispose() {
    _menuScrollController.removeListener(_menuScrollListener);
    _menuScrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _menuScrollListener() {
    for (int i = 0; i < categoryKeys.length; i++) {
      final RenderBox? renderBox =
          categoryKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero).dy;

        if (position >= 0 && position <= MediaQuery.of(context).size.height) {
          setState(() {
            currentCategoryIndex = i;
          });
          break;
        }
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double categoryPosition =
        currentCategoryIndex * 120.0 - (screenWidth - 120.0) / 2.0;

    _categoryScrollController.animateTo(
      categoryPosition.clamp(0, categories.length * 200 - screenWidth),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToCategory(int index) {
    setState(() {
      currentCategoryIndex = index;
    });

    final keyContext = categoryKeys[index].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _menuScrollController.jumpTo(
          index * (MediaQuery.of(context).size.height / categories.length));
    }

    double offset = index * 90.0;
    _categoryScrollController.animateTo(
      offset,
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
                controller: _menuScrollController,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryItem(index);
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

  Widget _buildCategoryItem(int index) {
    return SizedBox(
      key: categoryKeys[index],
      child: MenuCategories(categoryIndex: index),
    );
  }
}
