import 'package:e_commerce_app/models/product_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/shared/components/components.dart';

class OrdersDetailsScreen extends StatelessWidget {
  final int? orderNum;
  const OrdersDetailsScreen({this.orderNum ,super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        if (cubit.successfulTransaction[orderNum!].isNotEmpty) {
          List<ProductDetailModel> orders = cubit.successfulTransaction[orderNum!];
          return Scaffold(
            appBar: AppBar(
              title: Text('Order Num : ${orderNum! + 1}'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildChartItem(
                      model: orders[index],
                      index: index,
                      context: context,
                    ),
                    separatorBuilder: (context, index) => separateList(),
                    itemCount: orders.length,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('There is no product '),
          );
        }
      },
    );
  }
}

Widget buildChartItem({ProductDetailModel? model, index, context}) => Padding(
  padding: const EdgeInsets.all(15.0),
  child: Row(
    children: [
      Image(
        image: NetworkImage(extractUrls(model!.imageUrLs![0])!),
        width: 80,
        height: 120,
        fit: BoxFit.contain,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const SizedBox(
            height: 120,
            width: 80,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder:
            (BuildContext context, Object object, StackTrace? stackTrace) {
          return const SizedBox(
            height: 120,
            width: 80,
            child: Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
      const SizedBox(
        width: 20,
      ),
      Expanded(
        child: Text(
          model.title!,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  ),
);
