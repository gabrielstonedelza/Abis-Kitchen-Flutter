import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../global.dart';

class FavoritesController extends GetxController{
  bool isLoading = true;
  List allMyFavorites = [];
  List favoritesFoodNames = [];
  bool isAddingToFavorites = false;
  bool isFavorite = false;

  Future<void> getAllMyFavorites(String token) async{
    try{
      isLoading = true;
      const postUrl = "http://127.0.0.1:8000/get_my_favorites/";
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
        allMyFavorites.assignAll(allPosts);
        for(var i in allMyFavorites){
          if(!favoritesFoodNames.contains(i['get_food_name'])){
            favoritesFoodNames.assign(i['get_food_name']);
          }
        }
        update();
        // print(res.body);
      }
      else{

        // print(res.body);
      }
    }
    catch(e){
      Get.snackbar("Sorry", "please check your internet connection");
    }
    finally {
      isLoading = false;
      update();
    }
  }

  addToFavorites(String token,String slug,String name)async{
    final requestUrl = "http://127.0.0.1:8000/add_to_favorites/$slug/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    }, body: {
      "food": slug,
    });
    if (response.statusCode == 201) {
      isAddingToFavorites = false;
      Get.snackbar("Hurray 😀", "$name was added to your favorites",
          colorText: CupertinoColors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5));
    }
    else{
      isAddingToFavorites = false;
    }
  }

  removeFromFavorites(String id,String token,String name)async{
    final url = "http://127.0.0.1:8000/remove_from_favorites/$id/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    });

    if (response.statusCode == 204) {
      Get.snackbar("oh 😢", "$name was removed from your favorites",
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
  clearFavorites(String token)async{
    const postUrl = "http://127.0.0.1:8000/clear_favorites/";
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