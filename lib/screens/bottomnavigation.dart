import 'dart:async';

import 'package:abiskitchen/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/foodlist/foodlistcontroller.dart';
import 'cart.dart';
import 'favorites.dart';
import 'foodlist/foodlist.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FoodListController foodListController = Get.find();
  late Timer _timer;

  @override
  void initState(){
    super.initState();

    foodListController.getAllFoodLists();
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      foodListController.getAllFoodLists();
    });
  }



  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: "Cart"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: "Favorites"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile"),
              ],
            ),
            resizeToAvoidBottomInset: false,
            tabBuilder: ((context, index) {
              switch (index) {
                case 0:
                  return CupertinoTabView(
                    builder: (BuildContext context) => const FoodList(),
                  );
                  break;
                case 1:
                  return CupertinoTabView(
                    builder: (BuildContext context) => const Cart(),
                  );
                  break;
                case 2:
                  return CupertinoTabView(
                    builder: (BuildContext context) => const Favorites(),
                  );
                  break;
                case 3:
                  return CupertinoTabView(
                    builder: (BuildContext context) => const Profile(),
                  );
                  break;
              }
              return Container();
            })));
  }
}