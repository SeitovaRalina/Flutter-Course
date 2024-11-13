import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/bloc/menu_bloc.dart';
import 'package:flutter_course/src/features/menu/data/category_repository.dart';
import 'package:flutter_course/src/features/menu/data/data_sources/categories_data_source.dart';
import 'package:flutter_course/src/features/menu/data/data_sources/menu_data_source.dart';
import 'package:flutter_course/src/features/menu/data/menu_repository.dart';
import 'package:flutter_course/src/features/menu/view/menu_screen.dart';
import 'package:flutter_course/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dioClient = Dio(
      BaseOptions(
        baseUrl: 'https://coffeeshop.academy.effective.band/api/v1',
        headers: {'Content-Type': 'application/json'},
      ),
    );
    MenuRepository menuRepository = MenuRepository(
      networkMenuDataSource: NetworkMenuDataSource(dioClient),
    );
    CategoriesRepository categoriesRepository = CategoriesRepository(
      networkCategoriesDataSource: NetworkCategoriesDataSource(dioClient),
    );
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.title,
      theme: theme,
      home: BlocProvider(
        create: (context) => MenuBloc(
          menuRepository: menuRepository,
          categoryRepository: categoriesRepository,
        ),
        child: const MenuScreen(),
      ),
    );
  }
}
