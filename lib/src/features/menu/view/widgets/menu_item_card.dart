import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/features/order/bloc/order_bloc.dart';
import 'package:flutter_course/src/theme/app_colors.dart';
import 'package:flutter_course/src/theme/image_sources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem item;

  const MenuItemCard({required this.item, Key? key}) : super(key: key);

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int _quantity = 0;

  bool get showQuantityButtons => _quantity > 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state.status == OrderStatus.idle &&
            !state.items.containsKey(widget.item) &&
            _quantity > 0) {
          _quantity = 0;
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: 180,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  _buildImage(),
                  _buildTitle(),
                  _buildQuantityControls(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: widget.item.imageUrl ?? ImageSources.placeholder,
      height: 100,
      fit: BoxFit.contain,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator(color: AppColors.blue)),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        widget.item.name,
        style: Theme.of(context).textTheme.titleMedium,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildQuantityControls() {
    return SizedBox(
      height: 24,
      child: showQuantityButtons ? _buildQuantitySelector() : _buildBuyButton(),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildDecreaseButton(),
        _buildQuantityDisplay(),
        _buildIncreaseButton(),
      ],
    );
  }

  Widget _buildDecreaseButton() {
    return _buildIconButton(
      icon: Icons.remove,
      onPressed: () {
        setState(() {
          if (_quantity > 0) {
            _quantity--;
            context
                .read<OrderBloc>()
                .add(OrderItemCountChanged(widget.item, _quantity));
          }
        });
      },
    );
  }

  Widget _buildIncreaseButton() {
    return _buildIconButton(
      icon: Icons.add,
      onPressed: () {
        setState(() {
          if (_quantity < 10) {
            _quantity++;
            context
                .read<OrderBloc>()
                .add(OrderItemCountChanged(widget.item, _quantity));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(
                  AppLocalizations.of(context)!.increaseItemQuantityFailure,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColors.white),
                ),
              ),
            );
          }
        });
      },
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Ink(
        decoration: const ShapeDecoration(
          color: AppColors.blue,
          shape: CircleBorder(),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 9,
          ),
          color: AppColors.white,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildQuantityDisplay() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.blue,
          ),
          alignment: Alignment.center,
          child: Text(
            '$_quantity',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBuyButton() {
    return SizedBox(
      height: 24,
      child: TextButton(
        onPressed: () {
          setState(() {
            _quantity = 1;
          });
          context
              .read<OrderBloc>()
              .add(OrderItemCountChanged(widget.item, _quantity));
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColors.blue,
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            '${widget.item.price} ₽',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
