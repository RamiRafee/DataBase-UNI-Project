import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';


class PowerBiScreen extends StatelessWidget {
  const PowerBiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: customImages(cubit.imagesBI),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget customImages(List<String>? model) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: CarouselSlider(
          items: model
              ?.map((e) => Image(
                    image: AssetImage(e),
            fit: BoxFit.fill,

                  ))
              .toList(),
          options: CarouselOptions(
            viewportFraction: 1,
            height: double.infinity,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            //clipBehavior: Clip,
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
          ),
        ),
      );
}
