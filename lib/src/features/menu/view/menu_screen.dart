import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/bloc/menu_bloc.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/view/widgets/menu_categories.dart';
import 'package:flutter_course/src/features/order/bloc/order_bloc.dart';
import 'package:flutter_course/src/features/order/view/order_screen.dart';
import 'package:flutter_course/src/theme/app_colors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.background,
      statusBarIconBrightness: Brightness.dark,
    ),);

    context.read<MenuBloc>().add(const MenuCategoryLoadingStarted());

    _itemListener.itemPositions.addListener(() {
      final positions = _itemListener.itemPositions.value;

      if (positions.isNotEmpty) {
        final firstVisibleIndex = positions.first.index;
        final lastVisibleIndex = positions.last.index;
        final currentState = context.read<MenuBloc>().state;

        bool isLastVisibleItem = positions
            .any((e) => e.itemTrailingEdge > 0.8 || e.itemLeadingEdge > 0);
        final nextItems = currentState.items
            .where((e) => e.category.id - 1 == currentCategoryIndex + 1)
            .toList();

        if (lastVisibleIndex == currentState.categories.length - 1 &&
            positions.last.itemTrailingEdge == 1) {
          _setCurrentCategoryIndex(lastVisibleIndex);
        } else {
          if (currentCategoryIndex != firstVisibleIndex) {
            _setCurrentCategoryIndex(firstVisibleIndex);
            _scrollHorizontalToCategory(firstVisibleIndex);
          }
        }
        if (isLastVisibleItem && nextItems.isEmpty) {
          context.read<MenuBloc>().add(const MenuScreenLoadingStarted());
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
      duration: const Duration(milliseconds: 500),
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
              appBar: AppBar(
                backgroundColor: AppColors.background,
                surfaceTintColor: AppColors.background,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                title: SizedBox(
                  height: 36,
                  child: ScrollablePositionedList.builder(
                    itemScrollController: _categoryScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryButton(state.categories[index]);
                    },
                  ),
                ),
              ),
              body: ScrollablePositionedList.builder(
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
              floatingActionButton: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state.items.isNotEmpty) {
                    return FloatingActionButton.extended(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<OrderBloc>(),
                            child: const OrderScreen(),
                          ),
                        );
                      },
                      backgroundColor: AppColors.blue,
                      label: Text(
                        AppLocalizations.of(context)!.price(state.totalPrice),
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.white),
                      ),
                      icon: const Icon(
                        Icons.local_mall,
                        color: AppColors.white,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(color: AppColors.blue),
        );
      },
    );
  }

  Widget _buildCategoryButton(MenuCategory category) {
    final categoryIndex = category.id - 1;
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
