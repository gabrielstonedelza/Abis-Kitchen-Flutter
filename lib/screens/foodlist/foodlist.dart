import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/foodlist/favoritescontroller.dart';
import '../../controllers/foodlist/foodlistcontroller.dart';
import '../../controllers/foodlist/ordercontroller.dart';
import '../../controllers/login/logincontroller.dart';
import '../../controllers/notifications/notificationcontroller.dart';
import '../../controllers/userprofile/profilecontroller.dart';
import '../notifications.dart';
import 'fooddetail.dart';

class FoodList extends StatefulWidget {
  const FoodList({Key? key}) : super(key: key);

  @override
  State<FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  FoodListController foodListController = Get.find();
  LoginController loginController = Get.find();
  FavoritesController favoritesController = Get.find();
  OrderController orderController = Get.find();
  ProfileController profileController = Get.find();
  NotificationController notificationsController = Get.find();
  final searchController = TextEditingController();
  final storage = GetStorage();

  late String username = "";
  late String uToken = "";
  bool hasToken = false;
  late Timer _timer;
  var specialItems;

  @override
  void initState(){
    super.initState();
    if (storage.read("token") != null) {
      setState(() {
        hasToken = true;
        uToken = storage.read("token");
      });
    }
    if (storage.read("username") != null) {
      setState(() {
        username = storage.read("username");
      });
    }
    foodListController.getAllFoodLists(uToken);
    foodListController.getAllSidesFoodLists(uToken);
    orderController.getAllMyOrders(uToken);
    favoritesController.getAllMyFavorites(uToken);
    profileController.getUserProfile(uToken);
    notificationsController.getAllNotifications(uToken);
    notificationsController.getAllUnReadNotifications(uToken);
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      foodListController.getAllFoodLists(uToken);
      foodListController.getAllSidesFoodLists(uToken);
      orderController.getAllMyOrders(uToken);
      favoritesController.getAllMyFavorites(uToken);
      profileController.getUserProfile(uToken);
      notificationsController.getAllNotifications(uToken);
      notificationsController.getAllUnReadNotifications(uToken);
    });
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Row(
          children: const [
            Text("Explore Menu",style: TextStyle(fontWeight: FontWeight.bold,)),
          ],
        ),
        trailing: GetBuilder<NotificationController>(builder:(controller){
          return badges.Badge(
            position: badges.BadgePosition.topEnd(top: -10, end: -12),
            showBadge: true,
            badgeContent:
            Text(controller.notificationsUnread.length.toString(),style:const TextStyle(color:CupertinoColors.white)),
            badgeAnimation: const badges.BadgeAnimation.rotation(
              animationDuration: Duration(seconds: 1),
              colorChangeAnimationDuration: Duration(seconds: 1),
              loopAnimation: false,
              curve: Curves.fastOutSlowIn,
              colorChangeAnimationCurve: Curves.easeInCubic,
            ),

            child: GestureDetector(
              onTap: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                  return Notifications();
                }));
              },
                child: const Icon(CupertinoIcons.bell_fill)),);
        }),
        // backgroundColor: CupertinoColors.black,
      ), child: SlideInUp(
      animate: true,
        child: Padding(
          padding: const EdgeInsets.only(top:18.0,bottom:18,left:12,right:12),
          child: GetBuilder<FoodListController>(builder:(controller){
            return SizedBox(
              // height:double.infinity,
              // width: 300,
              child: ListView.builder(
                // scrollDirection: Axis.horizontal,
                  itemCount: controller.allFoodLists != null ? controller.allFoodLists.length : 0,
                  itemBuilder: (context,index){
                    specialItems = controller.allFoodLists[index];
                    return GestureDetector(
                      onTap:(){
                        Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                          return FoodDetail(name:controller.allFoodLists[index]['name'],price:controller.allFoodLists[index]['price'],pic:controller.allFoodLists[index]['get_food_image'],slug:controller.allFoodLists[index]['slug'],id:controller.allFoodLists[index]['id'].toString());
                        }));
                      },
                      child: Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          children: [
                            Image.network(specialItems['get_food_image'],width:MediaQuery.of(context).size.width,height:200,fit: BoxFit.cover,),
                            Padding(
                              padding: const EdgeInsets.only(top:18.0,bottom:10),
                              child: Text(specialItems['name'],style:const TextStyle(fontWeight: FontWeight.bold,fontSize:15)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:10,right:10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$${specialItems['price']}",style:const TextStyle(fontWeight: FontWeight.bold,color:CupertinoColors.destructiveRed)),
                                  GetBuilder<OrderController>(builder:(orController){
                                    return GestureDetector(
                                        onTap: (){
                                          orController.addToCart(uToken, controller.allFoodLists[index]['slug'], controller.allFoodLists[index]['name'],1.toString());
                                        },
                                        child: const Icon(CupertinoIcons.cart_badge_plus,size: 30,)
                                    );
                                  })

                                ],
                              ),
                            ),
                          ],
                        )
                        ),
                      );
                  }),
            );
          }),
        ),
      ),
    );
  }
}
