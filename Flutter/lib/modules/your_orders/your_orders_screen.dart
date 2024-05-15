import 'package:e_commerce_app/models/product_details_model.dart';
import 'package:e_commerce_app/modules/your_orders/orders_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/shared/components/components.dart';

// ignore: must_be_immutable
class YourOrdersScreen extends StatelessWidget {
  const YourOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // if(state is ShopSuccessTransactionStates){
        //   toast(msg: 'Successful Transaction', state: ToastState.success);
        // }
      },
      builder: (context, state) {
        if (cubit.successfulTransaction.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => buildChartItem(
                    model: cubit.successfulTransaction[index],
                    index: index,
                    context: context,
                  ),
                  separatorBuilder: (context, index) => separateList(),
                  itemCount: cubit.successfulTransaction.length,
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('There is no Orders'),
          );
        }
      },
    );
  }
}

Widget buildChartItem({List<ProductDetailModel>? model, index, context}) => InkWell(
  onTap: (){
    navigateTo(context, OrdersDetailsScreen(orderNum: index,));
  },
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(
      children: [
        Image(
          image: NetworkImage(extractUrls(model![index].imageUrLs![0])!),
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
            'Order Number : ${index+1}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  ),
);
