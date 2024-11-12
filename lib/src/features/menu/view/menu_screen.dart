import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/bloc/menu_bloc.dart';
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

    context.read<MenuBloc>().add(const CategoryLoadingStarted());

    _itemListener.itemPositions.addListener(() {
      final positions = _itemListener.itemPositions.value;

      if (positions.isNotEmpty) {
        final firstVisibleIndex = positions.first.index;
        bool isLastVisibleItem = positions
            .any((e) => e.itemTrailingEdge > 0.8 || e.itemLeadingEdge > 0);
        final nextItems = context
            .read<MenuBloc>()
            .state
            .items
            .where((e) => e.category.id - 1 == currentCategoryIndex + 1)
            .toList();

        if (currentCategoryIndex != firstVisibleIndex) {
          _setCurrentCategoryIndex(firstVisibleIndex);
          _scrollHorizontalToCategory(firstVisibleIndex);
        }
        if (isLastVisibleItem && nextItems.isEmpty) {
          context.read<MenuBloc>().add(const PageLoadingStarted());
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
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      opacityAnimationWeights: [20, 20, 60],
    );
  }

  void _scrollHorizontalToCategory(int index) {
    _categoryScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      opacityAnimationWeights: [20, 20, 60],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      buildWhen: (context, state) => state.status == MenuStatus.idle,
      builder: (context, state) {
        if (state.status != MenuStatus.error) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _categoryScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryButton(state.categories[index]);
                      },
                    ),
                  ),
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _menuScrollController,
                      itemPositionsListener: _itemListener,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        final items = state.items
                            .where((e) => e.category.id == category.id)
                            .toList();
                        return MenuCategories(category: category, items: items);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
            child: CircularProgressIndicator(color: AppColors.blue));
      },
    );
  }

  Widget _buildCategoryButton(MenuCategory category) {
    final categoryIndex = category.id - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: () {
          context.read<MenuBloc>().add(OneCategoryLoadingStarted(category));
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
          category.name,
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
