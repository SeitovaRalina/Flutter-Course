import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/bloc/menu_bloc.dart';
import 'package:flutter_course/src/features/menu/data/category_repository.dart';
import 'package:flutter_course/src/features/menu/data/data_sources/categories_data_source.dart';
import 'package:flutter_course/src/features/menu/data/data_sources/menu_data_source.dart';
import 'package:flutter_course/src/features/menu/data/menu_repository.dart';
import 'package:flutter_course/src/features/menu/view/menu_screen.dart';
import 'package:flutter_course/src/features/order/bloc/order_bloc.dart';
import 'package:flutter_course/src/features/order/data/data_sources/order_data_source.dart';
import 'package:flutter_course/src/features/order/data/order_repository.dart';
import 'package:flutter_course/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  static final dioClient = Dio(
    BaseOptions(
      baseUrl: 'https://coffeeshop.academy.effective.band/api/v1',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ICategoryRepository>(
          create: (_) => CategoriesRepository(
            networkCategoriesDataSource: NetworkCategoriesDataSource(dioClient),
          ),
        ),
        RepositoryProvider<IMenuRepository>(
          create: (_) => MenuRepository(
            networkMenuDataSource: NetworkMenuDataSource(dioClient),
          ),
        ),
        RepositoryProvider<IOrderRepository>(
          create: (_) => OrderRepository(
            networkOrderDataSource: NetworkOrderDataSource(dioClient),
          ),
        ),
      ],
      child: MaterialApp(
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
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => MenuBloc(
                menuRepository: context.read<IMenuRepository>(),
                categoryRepository: context.read<ICategoryRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => OrderBloc(
                orderRepository: context.read<IOrderRepository>(),
              ),
            ),
          ],
          child: const MenuScreen(),
        ),
      ),
    );
  }
}
