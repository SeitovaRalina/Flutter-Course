import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_course/src/features/menu/data/category_repository.dart';
import 'package:flutter_course/src/features/menu/data/menu_repository.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'menu_event.dart';
part 'menu_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IMenuRepository _menuRepository;
  final ICategoryRepository _categoryRepository;

  MenuBloc({
    required IMenuRepository menuRepository,
    required ICategoryRepository categoryRepository,
  })  : _menuRepository = menuRepository,
        _categoryRepository = categoryRepository,
        super(
          const MenuState(status: MenuStatus.idle, items: [], categories: []),
        ) {
    on<CategoryLoadingStarted>(_loadCategories);
    on<PageLoadingStarted>(
      _loadMenuItems,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  MenuCategory? _currentPaginatedCategory;
  int _currentPage = 0;
  final int _pageLimit = 25;

  Future<void> _loadCategories(CategoryLoadingStarted event, Emitter<MenuState> emit) async {
    emit(
      state.copyWith(items: state.items, status: MenuStatus.progress),
    );
    try {
      final categories = await _categoryRepository.loadCategories();
      emit(
        state.copyWith(
          categories: categories,
          items: List.empty(),
          status: MenuStatus.success,
        ),
      );
      add(
        const PageLoadingStarted(),
      );
    } on Object {
      emit(
        state.copyWith(
          categories: state.categories,
          items: state.items,
          status: MenuStatus.error,
        ),
      );
      rethrow;
    } finally {
      emit(
        state.copyWith(
          categories: state.categories,
          items: state.items,
          status: MenuStatus.idle,
        ),
      );
    }
  }

  Future<void> _loadMenuItems(PageLoadingStarted event, Emitter<MenuState> emit) async {
    List<MenuCategory>? categories = state.categories;

    _currentPaginatedCategory ??= categories.first;
    if (_currentPaginatedCategory == null) return;

    emit(
      state.copyWith(items: state.items, status: MenuStatus.progress),
    );
    try {
      final items = await _menuRepository.loadMenuItems(
        category: _currentPaginatedCategory!,
        page: _currentPage,
        limit: _pageLimit,
      );
      if (items.length < _pageLimit) {
        _currentPage++;
      }
      if (_currentPaginatedCategory != categories.last) {
          int nextPaginatedCategoryIndex =
              categories.indexOf(_currentPaginatedCategory!) + 1;

          _currentPaginatedCategory = categories[nextPaginatedCategoryIndex];
          _currentPage = 0;
      }
      emit(
        state.copyWith(
          categories: state.categories,
          items: List.of(state.items)..addAll(items),
          status: MenuStatus.success,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          categories: state.categories,
          items: state.items,
          status: MenuStatus.error,
        ),
      );
      rethrow;
    } finally {
      emit(
        state.copyWith(
          categories: state.categories,
          items: state.items,
          status: MenuStatus.idle,
        ),
      );
    }
  }
}
