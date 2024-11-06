import 'package:flutter_course/src/theme/image_sources.dart';

class MenuItem {
  final int categoryId;
  final String title;
  final int price;
  final String? imagePath;

  const MenuItem({
    required this.categoryId,
    required this.title,
    required this.price,
    this.imagePath,
  });
}

const List<MenuItem> menuItems = [
  MenuItem(
    categoryId: 0,
    title: 'Олеато',
    price: 180,
    imagePath: ImageSources.blackCoffee,
  ),
  MenuItem(
    categoryId: 0,
    title: 'Американо',
    price: 200,
    imagePath: ImageSources.blackCoffee,
  ),
  MenuItem(
    categoryId: 0,
    title: 'Эспрессо',
    price: 99,
    imagePath: ImageSources.blackCoffee,
  ),
  MenuItem(
    categoryId: 0,
    title: 'Айс кофе',
    price: 350,
    imagePath: ImageSources.blackCoffee,
  ),
  MenuItem(
    categoryId: 1,
    title: 'Капучино',
    price: 250,
    imagePath: ImageSources.coffeeWithMilk,
  ),
  MenuItem(
    categoryId: 1,
    title: 'Флэт Уайт',
    price: 200,
    imagePath: ImageSources.coffeeWithMilk,
  ),
  MenuItem(
    categoryId: 1,
    title: 'Латте',
    price: 250,
    imagePath: ImageSources.coffeeWithMilk,
  ),
  MenuItem(
    categoryId: 2,
    title: 'Чёрный',
    price: 20,
    imagePath: ImageSources.tea,
  ),
  MenuItem(
    categoryId: 2,
    title: 'Зеленый',
    price: 30,
    imagePath: ImageSources.tea,
  ),
  MenuItem(
    categoryId: 2,
    title: 'Улун',
    price: 40,
    imagePath: ImageSources.tea,
  ),
  MenuItem(
    categoryId: 3,
    title: 'Раф кокос',
    price: 279,
    imagePath: ImageSources.authorsDrink,
  ),
  MenuItem(
    categoryId: 3,
    title: 'Бамбл',
    price: 305,
    imagePath: ImageSources.authorsDrink,
  ),
  MenuItem(
    categoryId: 3,
    title: 'Сезонный',
    price: 305,
    imagePath: ImageSources.authorsDrink,
  ),
  MenuItem(
    categoryId: 4,
    title: 'Чизкейк',
    price: 300,
  ),
  MenuItem(
    categoryId: 4,
    title: 'Тирамису',
    price: 300,
  ),
  MenuItem(
    categoryId: 4,
    title: 'Брауни',
    price: 300,
  ),
];
