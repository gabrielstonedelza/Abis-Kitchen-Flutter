import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../global.dart';

class OrderController extends GetxController{
  bool isLoading = true;
  List allMyOrders = [];
  double sum = 0.0;
  bool isRemovingFromCart = false;

  Future<void> getAllMyOrders(String token) async{
    try{
      isLoading = true;
      const postUrl = "http://127.0.0.1:8000/get_my_cart_items/";
      final pLink = Uri.parse(postUrl);
      http.Response res = await http.get(pLink, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Accept': 'application/json',
        "Authorization": "Token $token"
      });
      if (res.statusCode == 200) {
        final codeUnits = res.body;
        var jsonData = jsonDecode(codeUnits);
        var allPosts = jsonData;
        allMyOrders.assignAll(allPosts);
        for(var i in allMyOrders) {
          sum = sum + double.parse(i['get_price']);
        }
        update();
        // print(allMyOrders);
      }
      else{
        // print(res.body);
      }
    }
    catch(e){
      // Get.snackbar("Sorry", "please check your internet connection");
    }
    finally {
      isLoading = false;
      update();
    }
  }

  addToCart(String token,String slug,String name,String quantity)async{
    final requestUrl = "http://127.0.0.1:8000/add_to_cart/$slug/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    }, body: {
      "food": slug,
      "quantity": quantity,
    });
    if (response.statusCode == 201) {
      Get.snackbar("Hurray 😀", "$name was added to your cart",
          colorText: CupertinoColors.white,
          snackPosition: SnackPosition.TOP,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5));
    }
    else{
      Get.snackbar("Order Error", "item is already in your cart.",
        duration: const Duration(seconds:5),
        colorText: Colors.white,
        // backgroundColor: primaryColor,
      );
    }
  }

  removeFromCart(String id,String token,String name)async{
    final url = "http://127.0.0.1:8000/remove_from_cart/$id/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    });

    if (response.statusCode == 204) {
      Get.snackbar("Hurray 😢", "$name was removed from your cart",
          colorText: CupertinoColors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5));
    }
    else{
      Get.snackbar("Sorry 😝", "something went wrong. Please try again later",
          colorText: CupertinoColors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: CupertinoColors.destructiveRed,
          duration: const Duration(seconds: 5));
    }
  }

  clearCart(String token)async{
    const postUrl = "http://127.0.0.1:8000/clear_cart/";
    final pLink = Uri.parse(postUrl);
    http.Response res = await http.get(pLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    });
    if (res.statusCode == 204) {
      // final codeUnits = res.body;
      // var jsonData = jsonDecode(codeUnits);
      // var allPosts = jsonData;
      // allMyOrders.assignAll(allPosts);
      update();
      // print(allMyOrders);
    }
    else{
      // print(res.body);
    }

  }
}