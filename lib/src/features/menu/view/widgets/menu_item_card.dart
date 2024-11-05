import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';
import 'package:flutter_course/src/theme/app_colors.dart';
import 'package:flutter_course/src/theme/image_sources.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem item;

  const MenuItemCard({Key? key, required this.item}) : super(key: key);

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int _quantity = 0;

  bool get showQuantityButtons => _quantity > 0;

  @override
  Widget build(BuildContext context) {
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
  }

  Widget _buildImage() {
    return Image.asset(
      widget.item.imagePath ?? ImageSources.placeholder,
      height: 100,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        widget.item.title,
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
          if (_quantity > 0) _quantity--;
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
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Превышено количество товаров в корзине'),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        height: 24,
        width: 52,
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
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColors.blue,
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            '${widget.item.price} руб',
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
