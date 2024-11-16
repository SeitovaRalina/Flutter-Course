import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/order/bloc/order_bloc.dart';
import 'package:flutter_course/src/features/order/view/widgets/order_list.dart';
import 'package:flutter_course/src/theme/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.81,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    AppLocalizations.of(context)!.yourOrder,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(const OrderDeleted());
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.delete_outlined,
                      size: 24,
                      color: AppColors.iconDelete,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.divider),
            Expanded(
              child: OrderList(
                items: context.watch<OrderBloc>().state.items,
              ),
            ),
            BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state.status == OrderStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(
                        AppLocalizations.of(context)!.orderSuccess,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                } else if (state.status == OrderStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(
                        AppLocalizations.of(context)!.orderFailure,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  );
                }
              },
              child: TextButton(
                onPressed: () {
                  context.read<OrderBloc>().add(const OrderPosted());
                },
                style: TextButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 56)),
                child: Text(
                  AppLocalizations.of(context)!.makeOrder,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
