import 'dart:convert';

import 'package:http/http.dart' as http;
import "package:get/get.dart";

class FoodListController extends GetxController{

  bool isLoading = true;
  List allFoodLists = [];
  List localFoodLists = [];
  List allSpecialLists = [];
  List allRegularLists = [];
  List allSidesLists = [];


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

  Future<void> getAllSidesFoodLists(String token) async{
    try{
      isLoading = true;
      const postUrl = "http://127.0.0.1:8000/sides/";
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
        allSidesLists.assignAll(allPosts);
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
