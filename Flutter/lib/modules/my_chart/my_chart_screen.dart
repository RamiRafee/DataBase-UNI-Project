import 'package:e_commerce_app/models/product_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/shared/components/components.dart';

class MyChartScreen extends StatelessWidget {
  const MyChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessTransactionStates){
          toast(msg: 'Successful Transaction', state: ToastState.success);
        }
        else if(state is ShopErrorTransactionStates){
          toast(msg: 'Transaction Failed', state: ToastState.error);
        }
      },
      builder: (context, state) {
        if (cubit.myChart.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => buildChartItem(
                    model: cubit.myChart[index],
                    index: index,
                    context: context,
                  ),
                  separatorBuilder: (context, index) => separateList(),
                  itemCount: cubit.myChart.length,
                ),
              ),
              //const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: defaultButton(
                  function: () {
                    cubit.newTransaction();
                  },
                  text: 'buy now',
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('There is no product in your chart'),
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
          IconButton(
            onPressed: () {
              ShopCubit.get(context).removeFromChart(index: index);
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
