import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:e_commerce_app/models/landing.dart';
import 'package:e_commerce_app/modules/product_details/product_details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/shared/components/components.dart';
import 'package:e_commerce_app/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);
    int crossItemCount = MediaQuery.of(context).size.width ~/250;
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessProductDataStates) {
          navigateTo(context, const ProductDetails());
        }
        else if (state is ShopErrorProductDataStates) {
          toast(msg: 'Connection Error', state: ToastState.error);
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: cubit.landingProduct != null,
          builder: (context) => builder(cubit.landingProduct!, context ,crossItemCount),
          fallback: (context) => (state is! ShopErrorHomeDataStates &&
                  state is! GetBrandErrorState &&
                  state is! ShopChangeBottomNavState &&
                  state is! SearchInitialState)
              ? const Center(child: CircularProgressIndicator())
              : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('There is a problem in your network'),
                        // const SizedBox(height: 20,),
                        // defaultButton(function: (){
                        //   navigateToFinish(context, const Intro());
                        // }, text: 'update your ip address'),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget builder(LandingModel model, context ,int crossItemCount) => Padding(
    padding: const EdgeInsets.only(right: 20.0),
    child: SingleChildScrollView(
          child: kIsWeb ?
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossItemCount,
              children: List.generate(
                model.landingProduct!.length,
                    (index) =>
                    buildGridProduct(model.landingProduct![index], context),
              ),
            ),
          ) :Container(
            color: Colors.grey[300],
            child: GridView.count(
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.77,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: List.generate(
                model.landingProduct!.length,
                (index) =>
                    buildGridProduct(model.landingProduct![index], context),
              ),
            ),
          ),
        ),
  );

  Widget buildGridProduct(LandingProduct model, BuildContext context) =>
      InkWell(
        onTap: () {
          ShopCubit.get(context).getProductData(asin: model.asin!);
        },
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                //flex: 1,
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    image(extractUrls(model.imageUrLs![0])),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        model.title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            model.price ?? 'not available',
                            style: const TextStyle(
                              fontSize: 12,
                              color: defaultColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget image(String? url) => Image(
        image: NetworkImage(url!),
        width: double.infinity,
        height: 200,
        errorBuilder:
            (BuildContext context, Object object, StackTrace? stackTrace) {
          return kIsWeb ? const SizedBox(
            height: 200,
            width: double.infinity,
            child: Center(
              child: Image(image: AssetImage('assets/images/no_product.png'),
              fit: BoxFit.cover,),
            ),
          ) :const SizedBox(
            height: 200,
            width: double.infinity,
            child: Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
          );
        },
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const SizedBox(
            height: 200,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
}

// Widget buildCategoryItem(DataCatModel model) => Stack(
//       alignment: AlignmentDirectional.bottomCenter,
//       children: [
//         Image(
//           image: NetworkImage(model.image!),
//           height: 100,
//           width: 100,
//           fit: BoxFit.cover,
//           loadingBuilder: (BuildContext context, Widget child,
//               ImageChunkEvent? loadingProgress) {
//             if (loadingProgress == null) {
//               return child;
//             }
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//           errorBuilder:
//               (BuildContext context, Object object, StackTrace? stackTrace) {
//             return const SizedBox(
//               height: 100,
//               width: 100,
//               child: Center(
//                 child: Icon(
//                   Icons.error,
//                   color: Colors.red,
//                 ),
//               ),
//             );
//           },
//         ),
//         Container(
//           color: Colors.black.withOpacity(0.8),
//           width: 100,
//           height: 20,
//           alignment: AlignmentDirectional.bottomCenter,
//           child: Text(
//             model.name!,
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//       ],
//     );

// Widget productsBuilder(HomeModel model, CategoriesModel categoriesModel,
//         BuildContext context) =>
//     SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CarouselSlider(
//             items: model.data!.banners
//                 ?.map((e) => Image(
//                       image: NetworkImage(
//                         '${e.image}',
//                       ),
//                       loadingBuilder: (BuildContext context, Widget child,
//                           ImageChunkEvent? loadingProgress) {
//                         if (loadingProgress == null) {
//                           return child;
//                         }
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       },
//                       errorBuilder: (BuildContext context, Object object,
//                           StackTrace? stackTrace) {
//                         return const Center(
//                           child: Icon(
//                             Icons.error,
//                             color: Colors.red,
//                           ),
//                         );
//                       },
//                     ))
//                 .toList(),
//             options: CarouselOptions(
//               height: 250,
//               initialPage: 0,
//               enableInfiniteScroll: true,
//               reverse: false,
//               autoPlay: true,
//               autoPlayInterval: const Duration(seconds: 3),
//               autoPlayAnimationDuration: const Duration(seconds: 1),
//               autoPlayCurve: Curves.fastOutSlowIn,
//               scrollDirection: Axis.horizontal,
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Categories',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                   height: 100,
//                   child: ListView.separated(
//                     scrollDirection: Axis.horizontal,
//                     physics: const BouncingScrollPhysics(),
//                     itemBuilder: (context, index) =>
//                         buildCategoryItem(categoriesModel.data!.data![index]),
//                     separatorBuilder: (context, index) => const SizedBox(
//                       width: 10,
//                     ),
//                     itemCount: categoriesModel.data!.data!.length,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 const Text(
//                   'New Products',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Container(
//             color: Colors.grey[300],
//             child: GridView.count(
//               mainAxisSpacing: 1,
//               crossAxisSpacing: 1,
//               childAspectRatio: 1 / 1.77,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               children: List.generate(
//                 model.data!.products!.length,
//                 (index) =>
//                     buildGridProduct(model.data!.products![index], context),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

// Widget buildGridProduct(ProductModel model, BuildContext context) =>
//     Container(
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             alignment: AlignmentDirectional.bottomStart,
//             children: [
//               Image(
//                 image: NetworkImage(model.image!),
//                 width: double.infinity,
//                 height: 200,
//                 errorBuilder: (BuildContext context, Object object,
//                     StackTrace? stackTrace) {
//                   return const SizedBox(
//                     height: 200,
//                     width: double.infinity,
//                     child: Center(
//                       child: Icon(
//                         Icons.error,
//                         color: Colors.red,
//                       ),
//                     ),
//                   );
//                 },
//                 loadingBuilder: (BuildContext context, Widget child,
//                     ImageChunkEvent? loadingProgress) {
//                   if (loadingProgress == null) {
//                     return child;
//                   }
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               children: [
//                 Text(
//                   model.name!,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     height: 1.3,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       '${model.price.round()}',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: defaultColor,
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
