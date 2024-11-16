part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();
}

class MenuCategoryLoadingStarted extends MenuEvent {
  const MenuCategoryLoadingStarted();

  @override
  String toString() => 'MenuCategoryLoadingStarted';
  @override
  List<Object> get props => [];
}

class MenuScreenLoadingStarted extends MenuEvent {
  const MenuScreenLoadingStarted();

  @override
  String toString() => 'MenuScreenLoadingStarted';
  @override
  List<Object> get props => [];
}
