import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:e_commerce_app/modules/product_of_brands/product_of_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/shared/components/components.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessProductBrandsStates) {
          navigateTo(context, ProductsOfBrandsScreen(title: cubit.productOfBrands!.landingProduct![0].title,));
        }
        else if(state is ShopErrorProductBrandsStates){
          toast(msg: 'Connection Error', state: ToastState.error);
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: cubit.brands != null,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildCatItem(cubit.brands!.search![index],context),
            separatorBuilder: (context, index) => separateList(),
            itemCount: cubit.brands!.search!.length,
          ),
          fallback: (context)=>Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text('There is nothing to show',style: Theme.of(context).textTheme.titleMedium,),
            ),
          ),
        );
        // if(cubit.brands!.search!.isNotEmpty) {
        //   return ListView.separated(
        //   itemBuilder: (context, index) => buildCatItem(cubit.brands!.search![index],context),
        //   separatorBuilder: (context, index) => separateList(),
        //   itemCount: cubit.brands!.search!.length,
        // );
        // }
        // else{
        //   return Center(
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 40),
        //       child: Text('There is nothing to show',style: Theme.of(context).textTheme.titleMedium,),
        //     ),
        //   );
        // }
      },
    );
  }
}

Widget buildCatItem(String? model ,context) => InkWell(
  onTap: (){
    ShopCubit.get(context).getProductOfBrands(brandName: model);
  },
  child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                model!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
);



// Image(
//   image: NetworkImage(model.image!),
//   width: 80,
//   height: 120,
//   fit: BoxFit.cover,
//   loadingBuilder: (BuildContext context, Widget child,
//       ImageChunkEvent? loadingProgress) {
//     if (loadingProgress == null) {
//       return child;
//     }
//     return const CircularProgressIndicator();
//   },
//   errorBuilder: (BuildContext context , Object object , StackTrace? stackTrace){
//     return const SizedBox(
//       height: 120,
//       width: 80,
//       child: Center(
//         child: Icon(
//           Icons.error,
//           color: Colors.red,
//         ),
//       ),
//     );
//   },
// ),
// const SizedBox(
//   width: 20,
// ),
