import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/shop_app_login.dart';
import 'package:e_commerce_app/modules/login/states.dart';
import 'package:e_commerce_app/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{
  ShopLoginCubit(): super(ShopLoginInitialState());

  late ShopLoginModel loginModel ;

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({required String email , required String password}){
    emit(ShopLoginLoadingState());

    DioHelper.postData(
        formData: FormData.fromMap({
          "action":"login",
          "Username":email,
          "Password":password,
    })).then((value) {
      loginModel = shopLoginModelFromJson(value.data);
      if (kDebugMode) {
        print(value.data);
      }
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error){
      if (kDebugMode) {
        print('login error #######################');
        print(error.toString());

      }
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined :Icons.visibility_off_outlined ;
    emit(ShopLoginChangePasswordVisibilityState());

  }
}