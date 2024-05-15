import 'package:e_commerce_app/layout/shop_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/shared/components/components.dart';

// ignore: must_be_immutable
class AddProduct extends StatelessWidget {
  AddProduct({super.key});

  int currentStep = 0;
  var titleController = TextEditingController();
  var asinController = TextEditingController();
  var priceController = TextEditingController();
  var phoneController = TextEditingController();
  var brandNameController = TextEditingController();
  var categoryController = TextEditingController();
  var productDetailsController = TextEditingController();
  var featuresDetailsController = TextEditingController();
  var maliciousUrlController = TextEditingController();
  var imageUrlController = TextEditingController();
  var locationController = TextEditingController();
  var industryController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  void makeTextEmpty() {
    titleController.text = '';
    asinController.text = '';
    priceController.text = '';
    brandNameController.text = '';
    categoryController.text = '';
    featuresDetailsController.text = '';
    productDetailsController.text = '';
    locationController.text = '';
    industryController.text = '';
    maliciousUrlController.text = '';
    imageUrlController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessAddProductStates) {
          if (cubit.addProductModel!.status == 'success') {
            cubit.changeCurrentStep(0);
            cubit.changeCurrentIndex(0, context);
            navigateToFinish(context, const ShopLayoutScreen());

            cubit.getHomeData();
            makeTextEmpty();
            toast(
              msg: 'Product has been added successfully',
              state: ToastState.success,
            );
          } else if (cubit.addProductModel!.status == 'error') {
            // cubit.changeCurrentStep(0);
            // cubit.changeCurrentIndex(0, context);
            // navigateToFinish(context, const ShopLayoutScreen());
            //
            // cubit.getHomeData();
            // makeTextEmpty();
            toast(
              msg: '${cubit.addProductModel!.message!} ,${cubit.addProductModel!.url!.predictedType!} ',
              state: ToastState.error,
            );
          }
        } else if (state is ShopErrorAddProductStates) {
          toast(
            msg: 'Error when add product',
            state: ToastState.error,
          );
        }
      },
      builder: (context, state) {
        List<Step> getSteps() => [
              Step(
                state: cubit.currentStep > 0
                    ? StepState.complete
                    : StepState.indexed,
                isActive: cubit.currentStep >= 0,
                title: const Text('Product'),
                content: firstStep(
                  context: context,
                  catController: categoryController,
                  priceController: priceController,
                  titleController: titleController,
                  asinController: asinController,
                  brandController: brandNameController,
                ),
              ),
              Step(
                state: cubit.currentStep > 1
                    ? StepState.complete
                    : StepState.indexed,
                isActive: cubit.currentStep >= 1,
                title: const Text('Details'),
                content: secondStep(
                    context: context,
                    productDetailsController: productDetailsController,
                    featuresController: featuresDetailsController,
                    locationController: locationController),
              ),
              Step(
                state: cubit.currentStep > 2
                    ? StepState.complete
                    : StepState.indexed,
                isActive: cubit.currentStep >= 2,
                title: const Text('Urls'),
                content: thirdStep(
                  maliciousController: maliciousUrlController,
                  imagesController: imageUrlController,
                  industryController: industryController,
                ),
              ),
            ];

        void continueFun() {
          if (cubit.currentStep != 2) {
            cubit.continueCurrentStep();
          } else {
            if (titleController.text.isNotEmpty &&
                asinController.text.isNotEmpty &&
                priceController.text.isNotEmpty &&
                brandNameController.text.isNotEmpty &&
                categoryController.text.isNotEmpty &&
                featuresDetailsController.text.isNotEmpty &&
                productDetailsController.text.isNotEmpty &&
                locationController.text.isNotEmpty &&
                industryController.text.isNotEmpty &&
                maliciousUrlController.text.isNotEmpty &&
                imageUrlController.text.isNotEmpty) {
              cubit.addNewProduct(
                  title: titleController.text,
                  asin: asinController.text,
                  price: priceController.text,
                  malicious: maliciousUrlController.text,
                  location: locationController.text,
                  productDetails: productDetailsController.text,
                  featuresDetails: featuresDetailsController.text,
                  category: categoryController.text,
                  image: imageUrlController.text,
                  industry: industryController.text,
                  brandName: brandNameController.text);
            } else {
              toast(
                msg: 'not complete data',
                state: ToastState.error,
              );
            }
          }
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              makeTextEmpty();
              Navigator.pop(context);
            },icon: const Icon(Icons.arrow_back),),
            title: const Text('Add Product'),
          ),
          body: Column(
            children: [
              if (state is ShopLoadingAddProductStates)
                const LinearProgressIndicator(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Stepper(
                      type: StepperType.horizontal,
                      steps: getSteps(),
                      currentStep: cubit.currentStep,
                      onStepCancel: () => cubit.cancelCurrentStep(),
                      onStepContinue: () => continueFun(),
                      onStepTapped: (step) => cubit.changeCurrentStep(step),
                      controlsBuilder: (context, ControlsDetails details) {
                        return Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: Text(cubit.currentStep != 2
                                      ? 'Next'
                                      : 'Confirm'),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              if (cubit.currentStep != 0)
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: details.onStepCancel,
                                    child: const Text('Back'),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

  }
}

Widget searchBrandWidget(context,brandNameController) =>Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    TextFormField(
      controller: brandNameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'enter brand name for search';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        //ShopCubit.get(context).search(value);
      },
      onChanged: (value) {
        ShopCubit.get(context).search(value);
      },
      decoration: const InputDecoration(
        label: Text('Brand Name'),
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    ),

    const SizedBox(height: 10),
    if(ShopCubit.get(context).model!.search!.isNotEmpty)
    Container(
      decoration:BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      height: 100,
      child: ListView.builder(
        itemCount: ShopCubit.get(context).model!.search!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ShopCubit.get(context).model!.search![index]),
            onTap: () {
              // Handle suggestion selection
              brandNameController.text = ShopCubit.get(context).model!.search![index];
              ShopCubit.get(context).setEmpty();

            },
          );
        },
      ),
    ),
  ],
);

Widget firstStep(
        {context,
        titleController,
        asinController,
        priceController,
        brandController,
        catController}) =>
    Column(
      children: [
        customField(
            label: 'Title',
            prefix: Icons.title_outlined,
            controller: titleController),
        const SizedBox(
          height: 10,
        ),
        customField(
            label: 'Asin', prefix: Icons.star, controller: asinController),
        const SizedBox(
          height: 10,
        ),
        customField(
            label: 'Price',
            prefix: Icons.euro_outlined,
            type: TextInputType.number,
            controller: priceController),
        const SizedBox(
          height: 10,
        ),
        searchBrandWidget(context,brandController),
        const SizedBox(
          height: 10,
        ),
        customField(
            label: 'Category', prefix: Icons.apps, controller: catController),
        const SizedBox(
          height: 10,
        ),
      ],
    );

Widget secondStep(
        {productDetailsController,
        featuresController,
        context,
        locationController}) =>
    Column(
      children: [
        customField(
            label: 'Product Details',
            prefix: Icons.info_outline,
            controller: productDetailsController),
        const SizedBox(
          height: 10,
        ),
        customField(
            label: 'Features Details',
            prefix: Icons.info_outline,
            controller: featuresController),
        const SizedBox(
          height: 10,
        ),
        customField(
            label: 'Location',
            prefix: Icons.location_city_outlined,
            controller: locationController),
        const SizedBox(
          height: 10,
        ),
      ],
    );

Widget thirdStep(
        {maliciousController, imagesController, context, industryController}) =>
    Column(
      children: [
        customField(
            label: 'Malicious Url',
            prefix: Icons.info_outline,
            controller: maliciousController),
        const SizedBox(
          height: 10,
        ),
        customField(
            label: 'Image Url',
            prefix: Icons.info_outline,
            controller: imagesController),
        const SizedBox(
          height: 10,
        ),
        customField(
            label: 'Industry',
            prefix: Icons.location_city_outlined,
            controller: industryController),
        const SizedBox(
          height: 10,
        ),
      ],
    );

Widget customField(
        {controller,
        type = TextInputType.name,
        String? validate,
        label = 'This field can not be empty.',
        prefix}) =>
    defaultFormField(
      onChange: (value) {},
      onTap: (value) {},
      onSubmit: (value) {},
      suffixPressed: () {},
      controller: controller,
      type: type,
      validate: (String value) {
        if (value.isEmpty) {
          return validate;
        }
      },
      label: label,
      prefix: prefix,
    );



