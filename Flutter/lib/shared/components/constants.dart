import 'package:e_commerce_app/platforms/dashboard_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce_app/modules/login/shop_login.dart';
import 'package:e_commerce_app/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';

import 'components.dart';

void logOut (context) {
  CacheHelper.removeData(key: 'token').then((value) {
    navigateToFinish(context, ShopLoginScreen());
  });
}

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) {
    if (kDebugMode) {
      print(match.group(0));
    }
  });
}

String token ='';
Widget adminWidget =  const DashboardDetails();

//String localhost ='192.168.1.11';