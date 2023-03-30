import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/foodlist/ordercontroller.dart';
import '../controllers/login/logincontroller.dart';
import '../global.dart';
import 'foodlist/fooddetail.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  OrderController controller = Get.find();
  LoginController loginController = Get.find();
  late String username = "";
  late String uToken = "";
  var items;
  final storage = GetStorage();
  double sum = 0.0;

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
    for(var i in controller.allMyOrders){
      setState(() {
        sum = sum + i['get_total_order_price'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Row(
          children:  [
            GetBuilder<OrderController>(builder:(controller){
              return Text("Cart(${controller.allMyOrders.length})",style: const TextStyle(fontWeight: FontWeight.bold,));
            })
          ],
        ),
        middle: GetBuilder<OrderController>(builder: (controller){
          return Text("Check Out(\$${controller.sum.toStringAsFixed(2)})",style:const TextStyle(color:primaryColor,fontWeight: FontWeight.bold));
        },),
        trailing: GestureDetector(
          onTap:(){
            if(controller.allMyOrders.isEmpty){
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
                  message: const Text("Are you sure you want to clear your cart?"),
                  actions: [
                    CupertinoActionSheetAction(
                        onPressed: (){
                          controller.clearCart(uToken);
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
            child: const Icon(CupertinoIcons.delete,color:CupertinoColors.destructiveRed)),
        // backgroundColor: CupertinoColors.black,
      ),
      child: GetBuilder<OrderController>(builder:(orderController){
        return ListView.builder(
          itemCount:orderController.allMyOrders != null ? orderController.allMyOrders.length : 0,
          itemBuilder: (context,index){
            items = orderController.allMyOrders[index];
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
                        return FoodDetail(name:orderController.allMyOrders[index]['get_food_name'],price:orderController.allMyOrders[index]['get_price'].toString(),pic:orderController.allMyOrders[index]['get_order_item_image'],slug:orderController.allMyOrders[index]['get_food_slug'],id:orderController.allMyOrders[index]['id'].toString());
                      }));
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(items['get_order_item_image'],width:80,height:100,fit: BoxFit.cover,)),
                    title: Padding(
                      padding: const EdgeInsets.only(left:8.0,bottom:8),
                      child: Text(items['get_food_name'],style:const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,bottom:8),
                          child: Text("\$${items['get_price'].toString()}",style:const TextStyle(fontWeight: FontWeight.bold,color:CupertinoColors.destructiveRed)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,bottom:8),
                          child: Text("\$${items['get_total_order_price'].toString()}",style:const TextStyle(fontWeight: FontWeight.bold,color:CupertinoColors.destructiveRed)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,bottom:8),
                          child: Text(items['get_order_item_category'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text(items['date_ordered'].toString().split('T').first),
                        ),

                        //  add two buttons here for adding and subtracting from cart,and also button to clear all order
                        Row(
                          children: [
                            IconButton(onPressed: () { 
                              orderController.decreaseQuantity(orderController.allMyOrders[index]['id'].toString(), orderController.allMyOrders[index]['get_food_slug'], uToken);
                            }, icon: const Icon(CupertinoIcons.minus_circle),),
                            Text(items['quantity'].toString(),style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            IconButton(onPressed: () {
                              orderController.increaseQuantity(orderController.allMyOrders[index]['id'].toString(), orderController.allMyOrders[index]['get_food_slug'], uToken); }, icon: const Icon(CupertinoIcons.add_circled),),
                          ],
                        )
                      ],
                    ),
                      trailing: GestureDetector(
                          onTap:(){
                            showCupertinoModalPopup(context: context, builder: (BuildContext context) {
                              return  CupertinoActionSheet(
                                title: const Text("Confirm"),
                                message: Text("Are you sure you want to remove ${orderController.allMyOrders[index]['get_food_name']} from your cart?"),
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: (){
                                        orderController.removeFromCart(orderController.allMyOrders[index]['id'].toString(),uToken,orderController.allMyOrders[index]['get_food_name']);
                                        orderController.getAllMyOrders(uToken);
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
                          child: const Icon(CupertinoIcons.delete,color:CupertinoColors.destructiveRed)),
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