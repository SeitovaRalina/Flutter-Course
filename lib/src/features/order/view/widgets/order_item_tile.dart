import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/theme/image_sources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({super.key, required this.item});
  final MenuItem item;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: item.imageUrl ?? ImageSources.placeholder ,
        placeholder: (context, url) => const Center(
          child: SizedBox.shrink(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.contain,
        width: 55,
      ),
      title: Text(
        item.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Text(
        AppLocalizations.of(context)!.price(item.price),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}