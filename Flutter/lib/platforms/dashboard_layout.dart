import 'package:e_commerce_app/modules/products/products_screen.dart';
import 'package:flutter/material.dart';


class DashboardDetails extends StatelessWidget {
  const DashboardDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: ProductsScreen(),
        ),
      ],
    );
  }
}
