import 'package:e_commerce_app/models/shop_app_register.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates{}

class ShopRegisterLoadingState extends ShopRegisterStates{}

class ShopRegisterSuccessState extends ShopRegisterStates{
  final ShopRegisterModel registerModel;

  ShopRegisterSuccessState(this.registerModel);
}

class ShopRegisterErrorState extends ShopRegisterStates{
  final String error;
  ShopRegisterErrorState(this.error);
}

class ShopRegisterChangePasswordVisibilityState extends ShopRegisterStates{}

class ShopRegisterContinueState extends ShopRegisterStates{}

class ShopRegisterCancelState extends ShopRegisterStates{}

class ShopRegisterChangeStepState extends ShopRegisterStates{}



class ShopRegisterGenderState extends ShopRegisterStates{}
