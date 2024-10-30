class MenuCategory {
  final int categoryId;
  final String title;

  const MenuCategory({required this.categoryId, required this.title});
}

const List<MenuCategory> categories = [
  MenuCategory(categoryId: 0, title: 'Черный кофе'),
  MenuCategory(categoryId: 1, title: 'Кофе с молоком'),
  MenuCategory(categoryId: 2, title: 'Чай'),
  MenuCategory(categoryId: 3, title: 'Авторские напитки'),
  MenuCategory(categoryId: 4, title: 'Десерты'),
];
