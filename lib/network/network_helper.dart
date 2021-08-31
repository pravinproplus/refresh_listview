import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class NetworkHelper {
  NetworkHelper({@required this.url});
  String? url;
  Dio dio = Dio();
  var data;
  Future getData() async {
    try {
      Response response = await dio.get(url!);
      data = response.data;
      //print(data);
      return data;
    } catch (e) {
      print(e);
    }
  }
}
