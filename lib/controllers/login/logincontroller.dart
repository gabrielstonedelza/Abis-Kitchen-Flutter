import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../screens/bottomnavigation.dart';


class LoginController extends GetxController{
  final client = http.Client();
  late String username;
  late String password;
  final storage = GetStorage();
  bool isLoggingIn = false;
  bool isUser = false;
  late TextEditingController usernameController,passwordController;
  static LoginController get to => Get.find<LoginController>();
  String errorMessage = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> loginUser(String uName,String password,context) async{
    const loginUrl = "http://127.0.0.1:8000/auth/token/login";
    final myLink = Uri.parse(loginUrl);
    http.Response response = await client.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "email": uName,
      "password": password
    });

    if(response.statusCode == 200){
      final resBody = response.body;
      var jsonData = jsonDecode(resBody);
      var userToken = jsonData['auth_token'];
      storage.write("username", uName);
      storage.write("token", userToken);
      isLoggingIn = false;
      isUser = true;
      if(!isLoggingIn && isUser){
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_){
          return const MyHomePage();
        }), (route) => false);
      }

    }
    else{
      errorMessage = "Unable to log in with provided credentials.";
      // print(response.body);
        isLoggingIn = false;
        isUser = false;
    }
  }
}