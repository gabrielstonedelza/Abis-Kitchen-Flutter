import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:abiskitchen/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/foodlist/favoritescontroller.dart';
import '../controllers/foodlist/foodlistcontroller.dart';
import '../controllers/foodlist/ordercontroller.dart';
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
  final storage = GetStorage();

  late String username = "";

  late String uToken = "";
  FoodListController foodListController = Get.find();
  FavoritesController favoritesController = Get.find();
  OrderController orderController = Get.find();
  late Timer _timer;

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled), label: "Home"),
                BottomNavigationBarItem(
                    icon: GetBuilder<OrderController>(builder:(controller){
                      return badges.Badge(
                          position: badges.BadgePosition.topEnd(top: -10, end: -12),
                          showBadge: true,
                          badgeContent:
                          Text(controller.allMyOrders.length.toString(),style:const TextStyle(color:CupertinoColors.white)),
                          badgeAnimation: const badges.BadgeAnimation.rotation(
                            animationDuration: Duration(seconds: 1),
                            colorChangeAnimationDuration: Duration(seconds: 1),
                            loopAnimation: false,
                            curve: Curves.fastOutSlowIn,
                            colorChangeAnimationCurve: Curves.easeInCubic,
                          ),

                          child: const Icon(CupertinoIcons.cart_fill),);
                    }),
                    ),
                BottomNavigationBarItem(
                    icon: GetBuilder<FavoritesController>(builder:(controller){
                      return badges.Badge(
                          position: badges.BadgePosition.topEnd(top: -10, end: -12),
                          showBadge: true,
                          badgeContent:
                          Text(controller.allMyFavorites.length.toString(),style:const TextStyle(color:CupertinoColors.white)),
                          badgeAnimation: const badges.BadgeAnimation.rotation(
                            animationDuration: Duration(seconds: 1),
                            colorChangeAnimationDuration: Duration(seconds: 1),
                            loopAnimation: false,
                            curve: Curves.fastOutSlowIn,
                            colorChangeAnimationCurve: Curves.easeInCubic,
                          ),
                          child: const Icon(CupertinoIcons.heart_fill));
                    })),
                const BottomNavigationBarItem(
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