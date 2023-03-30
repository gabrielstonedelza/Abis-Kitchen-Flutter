import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/foodlist/favoritescontroller.dart';
import '../controllers/login/logincontroller.dart';
import '../global.dart';
import 'foodlist/fooddetail.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  FavoritesController controller = Get.find();
  LoginController loginController = Get.find();
  late String username = "";
  late String uToken = "";
  var items;
  final storage = GetStorage();

  @override
  void initState(){
    super.initState();
    if (storage.read("token") != null) {
      setState(() {
        uToken = storage.read("token");
      });
    }
    if (storage.read("username") != null) {
      setState(() {
        username = storage.read("username");
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Row(
          children:  [
            GetBuilder<FavoritesController>(builder:(controller){
              return Text("Favorites(${controller.allMyFavorites.length})",style: const TextStyle(fontWeight: FontWeight.bold,));
            })
          ],
        ),
        trailing: GetBuilder<FavoritesController>(builder:(controller){
          return  GestureDetector(
              onTap:(){
                if(controller.allMyFavorites.isEmpty){
                  Get.snackbar("Error", "your cart is empty,please items to your cart.",
                    duration: const Duration(seconds:5),
                    colorText: Colors.white,
                    backgroundColor: primaryColor,
                  );
                }
                else{
                  showCupertinoModalPopup(context: context, builder: (BuildContext context) {
                    return  CupertinoActionSheet(
                      title: const Text("Confirm"),
                      message: const Text("Are you sure you want to clear your favorites?"),
                      actions: [
                        CupertinoActionSheetAction(
                            onPressed: (){
                              controller.clearFavorites(uToken);
                              Navigator.pop(context);
                            },
                            child:const Text("Yes")
                        ),
                        CupertinoActionSheetAction(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child:const Text("No")
                        ),
                      ],
                    );
                  });
                }

              },
              child: const Icon(CupertinoIcons.delete,color:CupertinoColors.destructiveRed));
        }),
        // backgroundColor: CupertinoColors.black,
      ),
      child: GetBuilder<FavoritesController>(builder:(controller){
        return ListView.builder(
          itemCount:controller.allMyFavorites != null ? controller.allMyFavorites.length : 0,
          itemBuilder: (context,index){
            items = controller.allMyFavorites[index];
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                color: CupertinoColors.extraLightBackgroundGray,
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: (){
                      Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                        return FoodDetail(name:controller.allMyFavorites[index]['get_food_name'],price:controller.allMyFavorites[index]['get_food_price'].toString(),pic:controller.allMyFavorites[index]['get_food_pic'],slug:controller.allMyFavorites[index]['food_slug'],id:controller.allMyFavorites[index]['id'].toString());
                      }));
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(items['get_food_pic'],width:80,height:100,fit: BoxFit.cover,)),
                    title: Padding(
                      padding: const EdgeInsets.only(left:8.0,bottom:8),
                      child: Text(items['get_food_name'],style:const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,bottom:8),
                          child: Text("\$${items['get_food_price'].toString()}",style:const TextStyle(fontWeight: FontWeight.bold,color:CupertinoColors.destructiveRed)),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text(items['date_added'].toString().split('T').first),
                        ),

                      ],
                    ),
                    trailing: GetBuilder<FavoritesController>(builder:(controller){
                      return GestureDetector(
                          onTap:(){
                            showCupertinoModalPopup(context: context, builder: (BuildContext context) {
                              return  CupertinoActionSheet(
                                title: const Text("Confirm"),
                                message: Text("Are you sure you want to remove ${controller.allMyFavorites[index]['get_food_name']} from your favorites?"),
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: (){
                                        controller.removeFromFavorites(controller.allMyFavorites[index]['id'].toString(),uToken,controller.allMyFavorites[index]['get_food_name']);
                                        controller.getAllMyFavorites(uToken);
                                        Navigator.pop(context);
                                      },
                                      child:const Text("Yes")
                                  ),
                                  CupertinoActionSheetAction(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child:const Text("No")
                                  ),
                                ],
                              );
                            });
                          },
                          child: const Icon(CupertinoIcons.delete,color:CupertinoColors.destructiveRed));
                    }),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}