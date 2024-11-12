part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();
}

class CategoryLoadingStarted extends MenuEvent {
  const CategoryLoadingStarted();

  @override
  String toString() => 'CategoryLoadingStarted';
  @override
  List<Object> get props => [];
}

class PageLoadingStarted extends MenuEvent {
  const PageLoadingStarted();

  @override
  String toString() => 'PageLoadingStarted';
  @override
  List<Object> get props => [];
}