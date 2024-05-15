import 'package:dio/dio.dart';
import 'package:e_commerce_app/models/shop_app_register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/modules/register/states.dart';
import 'package:e_commerce_app/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>{
  ShopRegisterCubit(): super(ShopRegisterInitialState());

  late ShopRegisterModel registerModel ;
  //int currentStep = 0;
  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  String? gender;
  void changeGender(String value){
    gender = value;
    emit(ShopRegisterGenderState());
  }

  void userRegister({required String username , required String password ,required String age , required String sex }){
    emit(ShopRegisterLoadingState());
    //print(localhost);
    DioHelper.postData(
      formData: FormData.fromMap({
        "action":"add_user",
        "user_lang":"en",
        "username":username,
        "password":password,
        "isAdmin":kIsWeb ? "1" :"0",
        "has_default_profile":"0",
        "has_default_profile_img":"0",
        "is_geo_enabled":"0",
        "membership_subscription":"subscription",
        "sex":sex,
        "age":age,
      }),
    ).then((value) {
      registerModel = shopRegisterModelFromJson(value.data);

      emit(ShopRegisterSuccessState(registerModel));
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined :Icons.visibility_off_outlined ;
    emit(ShopRegisterChangePasswordVisibilityState());

  }
}