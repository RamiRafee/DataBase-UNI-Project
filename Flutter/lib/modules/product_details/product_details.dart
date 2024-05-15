import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/models/product_details_model.dart';
import 'package:e_commerce_app/shared/components/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopAddToChartState){
          toast(msg: 'Add Successfully', state: ToastState.success);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.productDetailModel!.title!,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
          ),
          body: buildProduct(cubit.productDetailModel!, context),
        );
      },
    );
  }

  Widget buildProduct(ProductDetailModel model, BuildContext context) =>
      Container(
        alignment: Alignment.topCenter,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: kIsWeb ? CrossAxisAlignment.center: CrossAxisAlignment.start,
            children: [

              customImages(model.imageUrLs),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: kIsWeb ? CrossAxisAlignment.center: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    customRow(title: 'Title', text: model.title ?? ''),
                    customRow(title: 'Price', text: model.price ?? 'not available'),
                    customRow(title: 'Brand Name', text: model.brandName ?? 'not available'),
                    customRow(
                        title: 'Product Details', text: model.productDetails ?? 'not available'),
                    customRow(title: 'Category', text: model.category ?? 'not available'),
                    //customRow(title: 'Feature Details', text: model.featureDetails ?? 'not available'),
                    const SizedBox(height: 10,),
                    if(!kIsWeb)
                    defaultButton(function: (){
                      ShopCubit.get(context).addToChart(product: model);
                    }, text: 'add to chart')
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget customImages(List<String>? model) => Padding(
    padding: const EdgeInsets.all(15.0),
    child: CarouselSlider(
          items: model
              ?.map((e) => Image(
                    image: NetworkImage(

                      extractUrls(e)!,
                    ),
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const SizedBox(
                        height: 250,
                        //width: 80,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object object,
                        StackTrace? stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      );
                    },
                  ))
              .toList(),
          options: CarouselOptions(
            viewportFraction: 1,
            height: 250,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            //clipBehavior: Clip,
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
          ),
        ),
  );

  Widget customRow({String? text, String? title}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: kIsWeb ? CrossAxisAlignment.center:CrossAxisAlignment.start,
          mainAxisAlignment: kIsWeb ? MainAxisAlignment.center: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ),
            Expanded(
              child: Text(
                text!,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.3,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      );
}

// Image(
//   image: NetworkImage(extractUrls(model.imageUrl!)!),
//   width: double.infinity,
//   height: 200,
//   errorBuilder: (BuildContext context, Object object,
//       StackTrace? stackTrace) {
//     return const SizedBox(
//       height: 200,
//       width: double.infinity,
//       child: Center(
//         child: Icon(
//           Icons.error,
//           color: Colors.red,
//         ),
//       ),
//     );
//   },
//   loadingBuilder: (BuildContext context, Widget child,
//       ImageChunkEvent? loadingProgress) {
//     if (loadingProgress == null) {
//       return child;
//     }
//     return const Center(
//       child: CircularProgressIndicator(),
//     );
//   },
// ),
