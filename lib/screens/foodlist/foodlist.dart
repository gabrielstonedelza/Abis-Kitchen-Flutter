import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/foodlist/foodlistcontroller.dart';
import '../../controllers/login/logincontroller.dart';
import 'allregular.dart';
import 'allspecials.dart';
import 'fooddetail.dart';

class FoodList extends StatefulWidget {
  const FoodList({Key? key}) : super(key: key);

  @override
  State<FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  FoodListController foodListController = Get.find();
  LoginController loginController = Get.find();
  final searchController = TextEditingController();
  final storage = GetStorage();

  late String username = "";

  late String uToken = "";
  late Timer _timer;
  var specialItems;

  @override
  void initState(){
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }

    // foodListController.getAllFoodLists();
    // _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
    //   foodListController.getAllFoodLists();
    // });
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Row(
          children: const [
            Text("Explore",style: TextStyle(fontWeight: FontWeight.bold,)),
          ],
        ),
        trailing: const Icon(CupertinoIcons.bell_fill),
        // backgroundColor: CupertinoColors.black,
      ), child: Padding(
        padding: const EdgeInsets.only(top:18.0,bottom:18,left:12,right:12),
        child: ListView(
          children: [
            CupertinoSearchTextField(
              controller: searchController,
              onChanged: (value){},
            ),
            const SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Specials",style:TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                CupertinoButton(onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                    return const AllSpecials();
                  }));
                },
                child: const Text("View All",style:TextStyle(fontWeight: FontWeight.bold,fontSize:13,color: CupertinoColors.systemGrey)),)
              ],
            ),
            const SizedBox(height:20),
            foodListController.isLoading ? SizedBox(
              height:300,
              width: 300,
              child: Shimmer.fromColors(
                baseColor: Colors.red,
                highlightColor: Colors.yellow,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: SizedBox(
                      height:300,
                      width: 300,
                    ),
                  ),
                ),
              ),
            ) : GetBuilder<FoodListController>(builder:(controller){
              return SizedBox(
                height:300,
                width: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: foodListController.allFoodLists != null ? foodListController.allFoodLists.length : 0,
                    itemBuilder: (context,index){
                      specialItems = foodListController.allFoodLists[index];
                      return Padding(
                        padding: const EdgeInsets.only(right:8.0,left:8.0),
                        child: GestureDetector(
                          onTap:(){
                            Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                              return FoodDetail(name:foodListController.allFoodLists[index]['name'],price:foodListController.allFoodLists[index]['price'],pic:foodListController.allFoodLists[index]['get_food_image']);
                            }));
                          },
                          child: Card(
                            elevation: 12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: SizedBox(
                              height:300,
                              width: 300,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  children: [
                                    Hero(tag: "food-pick",
                                    child: Image.network(specialItems['get_food_image'],width:300,height:200,fit: BoxFit.cover,)),
                                    Padding(
                                      padding: const EdgeInsets.only(top:18.0,bottom:10),
                                      child: Text(specialItems['name'],style:const TextStyle(fontWeight: FontWeight.bold,fontSize:15)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:10,right:10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("\$${specialItems['price']}",style:const TextStyle(fontWeight: FontWeight.bold)),
                                          const Icon(CupertinoIcons.cart_badge_plus,size: 30,)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Regular",style:TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                CupertinoButton(onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                    return const AllRegular();
                  }));
                },
                  child: const Text("View All",style:TextStyle(fontWeight: FontWeight.bold,fontSize:14,color: CupertinoColors.systemGrey)),)
              ],
            ),
            const SizedBox(height:20),
            foodListController.isLoading ? SizedBox(
              height:300,
              width: 300,
              child: Shimmer.fromColors(
                baseColor: Colors.red,
                highlightColor: Colors.yellow,
                child: const Card(
                  child: SizedBox(
                    height:300,
                    width: 300,
                  ),
                ),
              ),
            ) :GetBuilder<FoodListController>(builder:(controller){
              return SizedBox(
                height:300,
                width: 300,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: foodListController.allFoodLists != null ? foodListController.allFoodLists.length : 0,
                    itemBuilder: (context,index){
                      specialItems = foodListController.allFoodLists[index];
                      return Padding(
                        padding: const EdgeInsets.only(right:8.0,left:8.0),
                        child: Card(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: SizedBox(
                            height:300,
                            width: 300,

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                children: [
                                  Image.network(specialItems['get_food_image'],width:300,height:200,fit: BoxFit.cover,),
                                  Padding(
                                    padding: const EdgeInsets.only(top:18.0,bottom:10),
                                    child: Text(specialItems['name'],style:const TextStyle(fontWeight: FontWeight.bold,fontSize:15)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:10,right:10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("\$${specialItems['price']}",style:const TextStyle(fontWeight: FontWeight.bold)),
                                        const Icon(CupertinoIcons.cart_badge_plus,size: 30,)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }),
          ],
        ),
      ),
    );
  }
}
