part of 'menu_bloc.dart';

enum MenuStatus {
  progress,
  success,
  error,
  idle,
}

final class MenuState extends Equatable {
  final MenuStatus status = MenuStatus.idle;
  final List<MenuCategory> categories;
  final List<MenuItem> items;

  const MenuState({
    required MenuStatus status,
    required this.categories,
    required this.items,
  });

  MenuState copyWith({
    MenuStatus? status,
    List<MenuCategory>? categories,
    List<MenuItem>? items,
  }) {
    return MenuState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return '''MenuStatus { status: $status, categories: ${categories.length}, items: ${items.length} }''';
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        items,
      ];
}
