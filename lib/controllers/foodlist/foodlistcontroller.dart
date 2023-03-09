import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import "package:get/get.dart";

class FoodListController extends GetxController{

  bool isLoading = true;
  List allFoodLists = [];
  List allSpecialLists = [];
  List allRegularLists = [];


  Future<void> getAllFoodLists(String token) async{
    try{
      isLoading = true;
      const postUrl = "http://127.0.0.1:8000/all-food/";
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
        allFoodLists.assignAll(allPosts);
        for(var i in allFoodLists){
          if(i['dish_type'] == "Special"){
            allSpecialLists.assignAll(i);
          }
          if(i['dish_type'] == "Regular"){
            allRegularLists.assignAll(i);
          }
        }
        update();

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

}
