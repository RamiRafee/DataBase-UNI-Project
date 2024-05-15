import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/modules/product_of_brands/product_of_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/shared/components/components.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessProductBrandsStates) {
          navigateTo(
              context,
              ProductsOfBrandsScreen(
                title: cubit.productOfBrands!.landingProduct![0].title,
              ));
        } else if (state is ShopErrorProductBrandsStates) {
          toast(msg: 'Connection Error', state: ToastState.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    cubit.setEmpty();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter brand name for search';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        ShopCubit.get(context).search(value);
                      },
                      onChanged: (value) {
                        ShopCubit.get(context).search(value);
                      },
                      decoration: const InputDecoration(
                        label: Text('Search'),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (state is SearchInitialState)
                        ? Container()
                        :
                    Expanded(
                            child: ConditionalBuilder(
                              condition: state is! SearchLoadingState,
                              builder: (context) =>
                              (cubit.model!.search!.isNotEmpty)
                                  ? Column(
                                      children: [
                                        Expanded(
                                          child: ListView.separated(
                                            itemBuilder: (context, index) =>
                                                buildSearchItem(
                                                    cubit.model!.search![index],
                                                    context),
                                            separatorBuilder:
                                                (context, index) =>
                                                    separateList(),
                                            itemCount:
                                                cubit.model!.search!.length,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          'There is nothing to show',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        )),
                                  ],
                                ),
                              ),
                              fallback: (context) =>
                                  const LinearProgressIndicator(),
                            ),
                          ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget buildSearchItem(String? model, BuildContext context) => InkWell(
        onTap: () {
          ShopCubit.get(context).getProductOfBrands(brandName: model);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 20,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    model!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
