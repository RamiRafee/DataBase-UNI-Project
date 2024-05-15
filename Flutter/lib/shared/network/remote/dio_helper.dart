import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioHelper {
  static late Dio dio ;
  static String url =kIsWeb
      ? 'http://localhost/abok/ecommerce-work.php'
      :'http://192.168.1.2/abok/ecommerce-work.php';

  static init()async{
    dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required Map<String,dynamic>data ,
  })async {
    return await dio.get(url ,queryParameters: data);
  }

  static Future<Response> postData({
    required var formData,
  })async{
    return await dio.post(url,data: formData);
  }
}