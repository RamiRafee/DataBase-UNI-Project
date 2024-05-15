import 'package:dio/dio.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/models/add_product_model.dart';
import 'package:e_commerce_app/models/default_user_by_admin.dart';
import 'package:e_commerce_app/models/fraud_product_model.dart';
import 'package:e_commerce_app/models/landing.dart';
import 'package:e_commerce_app/models/product_details_model.dart';
import 'package:e_commerce_app/models/search_model.dart';
import 'package:e_commerce_app/models/users_search.dart';
import 'package:e_commerce_app/modules/brands/brands_screen.dart';
import 'package:e_commerce_app/modules/my_chart/my_chart_screen.dart';
import 'package:e_commerce_app/modules/new_product/add_product.dart';
import 'package:e_commerce_app/modules/products/products_screen.dart';
import 'package:e_commerce_app/modules/search/search_screen.dart';
import 'package:e_commerce_app/modules/your_orders/your_orders_screen.dart';
import 'package:e_commerce_app/shared/components/components.dart';
import 'package:e_commerce_app/shared/components/constants.dart';
import 'package:e_commerce_app/shared/network/remote/dio_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_detection_model.dart';
import '../modules/users_state/search_user.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreen = [
    const ProductsScreen(),
    const BrandsScreen(),
    AddProduct(),
    const MyChartScreen(),
    const YourOrdersScreen(),
  ];

  void changeCurrentIndex(int index ,context) {
    if(index == 2) {
      navigateTo(context, bottomScreen[index]);
      emit(ShopChangeBottomNavState());
    }else{
      currentIndex = index;
      emit(ShopChangeBottomNavState());
    }
  }

  int drawerIndex =0;

  void changeDrawerIndex(int index) {
    emit(ShopChangeDrawerLState());
    drawerIndex = index;
    if(index != 5){
    if (kDebugMode) {
      print(drawerIndex);
    }
    emit(ShopChangeDrawerState());}
    else{
      emit(SearchInitialState());
    }
  }


  void getAllData(){
    getHomeData();
    getBrands();
    if(kIsWeb){
      getFraudData();
      //powerBiImages();
      if(token !='') {
        getUsersDefault();
      }
    }
  }


  LandingModel? landingProduct;

  void getHomeData() {
    emit(ShopLoadingHomeDataStates());

    DioHelper.getData(data: {'action': 'landing_page'}).then((value) {
      landingProduct = landingModelFromJson(value.data);
      //print(value.data);
      emit(ShopSuccessHomeDataStates());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorHomeDataStates());
    });
  }

  ProductDetailModel? productDetailModel;

  void getProductData({String? asin}) {
    emit(ShopLoadingProductDataStates());

    DioHelper.getData(data: {'action': 'product', 'asin': asin}).then((value) {
      productDetailModel = productDetailModelFromJson(value.data);
      if (kDebugMode) {
        print(value.data);
      }
      emit(ShopSuccessProductDataStates());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorProductDataStates());
    });
  }

  FraudulentProductsModel? fraudulentProductsModel;

  void getFraudData() {
    emit(ShopLoadingFraudStates());

    DioHelper.getData(data: {'action': 'admin_fraud_products'}).then((value) {
      fraudulentProductsModel = fraudulentProductsModelFromJson(value.data);
      //print(value.data);
      emit(ShopSuccessFraudStates());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorFraudStates());
    });
  }


  AddProductModel? addProductModel;
  void addNewProduct({
    String? title,
    String? asin,
    String? price,
    String? brandName,
    String? category,
    String? productDetails,
    String? featuresDetails,
    String? malicious,
    String? image,
    String? location,
    String? industry
}) {

    /*
    curl -X POST -d
    "action=add_product&
    title=product_titlea&
    asin=omkkk&
    price=100omk
    &brand_name=brand_namea&category=Examplee Category&
    product_details=details&feature_details=feature_details&malicious_url=www.amazon.com&image_url=image_url&location=location&has_company_logo=1&has_questions=1&industry=industry of omk" "http://localhost/abok/ecommerce-work.php"
     */
    emit(ShopLoadingAddProductStates());
    DioHelper.postData(formData: FormData.fromMap({
      'action': 'add_product',
      'title': title,
      'asin': asin,
      'price': price,
      'brand_name': brandName,
      'category': category,
      'product_details': productDetails,
      'feature_details': featuresDetails,
      'malicious_url': malicious,
      'image_url': image,
      'location': location,
      'has_company_logo': '1',
      'has_questions': '1',
      'industry': industry
    })).then((value) {
      addProductModel = addProductModelFromJson(value.data);
      if (kDebugMode) {
        print(value.data);
      }
      emit(ShopSuccessAddProductStates());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorAddProductStates());
    });
  }

  SearchModel? model = SearchModel.fromJson({"search":[]});

  void setEmpty(){
    model = SearchModel.fromJson({"search":[]});
    usersSearch = UsersSearch.fromJson({"search":[]});
    emit(SearchBrandSuccessState());
  }
  void goToSearch(context){
    setEmpty();
    navigateTo(context, SearchScreen());
    emit(SearchInitialState());
  }

  void search(String? search){
    emit(SearchBrandLoadingState());

    DioHelper.getData(data: {'action':'brand_search' , 'brand':search}).then((value) {
      model = searchModelFromJson(value.data);
      emit(SearchBrandSuccessState());
    }).catchError((error){
      //print(error.toString());
      model!.search =[];
      emit(SearchBrandErrorState());
    });
  }


  SearchModel? brands ;

  void getBrands(){
    emit(GetBrandLoadingState());

    DioHelper.getData(data: {'action':'brands'}).then((value) {
      brands = searchModelFromJson(value.data);
      emit(GetBrandSuccessState());
    }).catchError((error){
      //print(error.toString());
      emit(GetBrandErrorState());
    });
  }

  LandingModel? productOfBrands;

  void getProductOfBrands({String? brandName}) {
    emit(ShopLoadingProductBrandsStates());

    DioHelper.getData(data: {'action': 'products_by_brand', 'brand_name': brandName}).then((value) {
      productOfBrands = landingModelFromJson(value.data);
      //print(value.data);
      emit(ShopSuccessProductBrandsStates());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorProductBrandsStates());
    });
  }



  List<ProductDetailModel> myChart = [];
  List<List<ProductDetailModel>> successfulTransaction = [];

  void addToChart({ProductDetailModel? product}){
    myChart.add(product!);
    emit(ShopAddToChartState());
  }
  void removeFromChart({index}){
    myChart.removeAt(index);
    emit(ShopRemoveFromChartState());
  }

  void newTransaction() {
    String products ='';
    for (var element in myChart) {
      products = products == '' ? element.id!:"$products,${element.id!}" ;
    }
    if (kDebugMode) {
      print(products);
      print(token);
    }
    emit(ShopLoadingTransactionStates());
    DioHelper.postData(formData: FormData.fromMap({
      'action': 'transaction',
      'UserID': token,
      'DeviceID': 454,
      'DeviceType': 'Android',
      'IPAddress': 732758368.79972,
      'Country': 'Japan',
      'ProductIDs': '23267',
      'Browser': 'Mobile App',
      'source': 'facebook',
    })).then((value) {
      //productDetailModel = productDetailModelFromJson(value.data);
      if (kDebugMode) {
        print(value.data);
      }
      successfulTransaction.add(myChart);
      myChart =[];
      emit(ShopSuccessTransactionStates());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorTransactionStates());
    });
  }

  GetUserDefault? getUserDefault;

  void getUsersDefault() {

    emit(ShopLoadingDefaultUserStates());
    DioHelper.postData(formData: FormData.fromMap({
      'action': 'admin_get_users',
      'userid': token,
    })).then((value) {
      getUserDefault = getUserDefaultFromJson(value.data);
      // if (kDebugMode) {
      //   print(value.data);
      // }
      emit(ShopSuccessDefaultUserStates());
      rowDataTable();
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorDefaultUserStates());
    });
  }
  List<DataRow> rowTable = <DataRow>[];
  List<User> user =[];

  void rowDataTable(){
    rowTable = <DataRow>[];
    for(var element in getUserDefault!.users!){
      user.add(element);
      rowTable.add(DataRow(
        cells: <DataCell>[
          DataCell(Text(element.id!)),
          DataCell(Text(element.username!)),
          DataCell(Text(element.sex!.name=='M' ?'Male':'Female')),
          DataCell(Text(element.age!)),
        ],
      ),
      );
    }
  }

  int? selectedIndex;
  void changeSelectedIndex(index){

  }

  List<User> checkBots = [];
  List<UserDetectedModel>? detected ;

  void adminBotDetection(List<int> list) {
    checkBots =[];
    for(var element in list){
      checkBots.add(user[element]);
    }
    String users ='';
    for (var element in checkBots) {
      users = users == '' ? element.id!:"$users,${element.id!}" ;
    }
    emit(ShopLoadingDetectionStates());
    DioHelper.postData(formData: FormData.fromMap({
      'action': 'admin_bot_detection',
      'userids': users,
    })).then((value) {
      detected = userDetectedModelFromJson(value.data);
      if (kDebugMode) {
        print(value.data);
      }
      emit(ShopSuccessDetectionStates());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorDetectionStates());
    });
  }

  UsersSearch? usersSearch = UsersSearch.fromJson({"search":[]});

  void goToUserSearch(context){
    setEmpty();
    navigateTo(context, UserSearchScreen());
    emit(SearchInitialState());
  }
  void adminUserAutocomplete({String? userSearch}) {
    emit(ShopLoadingUserSearchStates());
    DioHelper.postData(formData: FormData.fromMap({
      'action': 'admin_user_autocomplete',
      'searchTerm': userSearch,
    })).then((value) {
      usersSearch = usersSearchFromJson(value.data);
      if (kDebugMode) {
        print(value.data);
      }
      emit(ShopSuccessUserSearchStates());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorUserSearchStates());
    });
  }

  // PowerBi? powerBi;
  //
  // void powerBiImages() {
  //   emit(ShopLoadingPowerBIStates());
  //   DioHelper.postData(formData: FormData.fromMap({
  //     'action': 'admin_powerBI',
  //   })).then((value) {
  //     powerBi = powerBiFromJson(value.data);
  //     if (kDebugMode) {
  //       print(value.data);
  //     }
  //     emit(ShopSuccessPowerBIStates());
  //   }).catchError((error) {
  //     if (kDebugMode) {
  //       print(error.toString());
  //     }
  //     emit(ShopErrorPowerBIStates());
  //   });
  // }

  int currentStep = 0;

  void changeCurrentStep(int step){
    currentStep = step;
    emit(ShopChangeStepState());
  }
  void continueCurrentStep(){
    if(currentStep == 2){

    }else {
      currentStep++;
      emit(ShopChangeStepState());
    }
  }
  void cancelCurrentStep(){
    if(currentStep !=0){
      currentStep--;
      emit(ShopChangeStepState());
    }
  }


  List<String> imagesBI=[
    //'assets/images/onboard_1.jpg',
    "assets/powerBi/Page1.png",
    "assets/powerBi/Page2.png",
    "assets/powerBi/Page3.png",
    "assets/powerBi/Page4.png",
    "assets/powerBi/Page5.png"
  ] ;

}



