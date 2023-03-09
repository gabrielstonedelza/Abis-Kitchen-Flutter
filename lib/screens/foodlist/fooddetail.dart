import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/foodlist/favoritescontroller.dart';
import '../../controllers/foodlist/foodlistcontroller.dart';
import '../../controllers/foodlist/ordercontroller.dart';
import '../../global.dart';

class FoodDetail extends StatefulWidget {
  final name;
  final price;
  final pic;
  final slug;
  final id;
  const FoodDetail({Key? key,required this.name,required this.price,required this.pic,required this.slug,required this.id}) : super(key: key);

  @override
  State<FoodDetail> createState() => _FoodDetailState(name:this.name,price:this.price,pic:this.pic,slug:this.slug,id:this.id);
}

class _FoodDetailState extends State<FoodDetail> {
  final name;
  final price;
  final pic;
  final slug;
  final id;
  int orderCount = 1;
  double itemPrice = 0.0;
  bool isZero = false;

  _FoodDetailState({required this.name,required this.price,required this.pic,required this.slug,required this.id});
  FoodListController controller = Get.find();
  FavoritesController favController = Get.find();
  OrderController orderController = Get.find();
  final storage = GetStorage();

  late String username = "";
  late String uToken = "";

  @override
  void initState(){
    super.initState();
    setState(() {
      itemPrice = double.parse(price);
    });
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
    if(favController.favoritesFoodNames.contains(name)){
      setState(() {
        favController.isFavorite = true;
      });
    }else{
      setState(() {
        favController.isFavorite = false;
      });
    }
    // print(favController.favoritesFoodNames);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Food list",
        // middle: Text(name),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GetBuilder<FavoritesController>(builder:(controller){
              return GestureDetector(
                  onTap: (){
                    if(controller.isFavorite){
                      Get.snackbar("😜", "$name is already in your favorites",
                          colorText: CupertinoColors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: primaryColor,
                          duration: const Duration(seconds: 5));
                    }
                    else{
                      controller.addToFavorites(uToken, slug, name);
                    }
                  },
                  child: controller.isFavorite ? const Icon(CupertinoIcons.heart_fill) :const Icon(CupertinoIcons.heart)
              );
            }),
          ],
        )
      ),
      child: ListView(
        children: [
          Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
                child: Image.network(pic,width: 300,height: 300,fit: BoxFit.cover,)),
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap:(){
                    setState(() {
                      if(orderCount == 0){
                        Get.snackbar("Order Error", "Your order is already 0",
                          colorText: Colors.white,
                          backgroundColor: primaryColor,
                          duration: const Duration(seconds:5)
                        );
                      }
                      else{
                        orderCount --;
                        itemPrice = itemPrice - double.parse(price);
                      }
                    });
                  },
                  child: Image.asset("assets/images/minus.png",width: 40, height:40)),
              Padding(
                padding: const EdgeInsets.only(left:18.0,right:18),
                child: Center(
                  child: Text(orderCount.toString()),
                ),
              ),
              GestureDetector(
                  onTap:(){
                    // controller.decrementOrderCount();
                    // print(controller.orderCount.toString());
                    setState(() {
                      orderCount ++;
                      itemPrice = itemPrice + double.parse(price);
                    });

                  },
                  child: Image.asset("assets/images/plus.png",width: 40, height:40)),
            ],
          ),
          const SizedBox(height: 20,),
          Center(
            child:Text(name,style:const TextStyle(fontWeight: FontWeight.bold,fontSize:20))
          ),
          const SizedBox(height: 20,),
          // const Text("lorem"),
          const SizedBox(height: 20,),
          GetBuilder<OrderController>(builder:(controller){
            return Padding(
              padding: const EdgeInsets.only(left:18.0,right:18),
              child: CupertinoButton.filled(
                  onPressed: (){
                    if(orderCount == 0){
                      Get.snackbar("Order Error", "your order quantity is 0 and therefore you cannot place this order.",
                        duration: const Duration(seconds:5),
                        colorText: Colors.white,
                        backgroundColor: primaryColor,
                      );
                    }
                    else{
                      if(controller.allMyOrders.contains(name)){
                        Get.snackbar("Order Error", "item is already in your cart.",
                          duration: const Duration(seconds:5),
                          colorText: Colors.white,
                          backgroundColor: primaryColor,
                        );
                      }
                      else{
                        controller.addToCart(uToken, slug, name,orderCount.toString());
                      }
                    }
                  },
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add to cart"),
                      SlideInUp(
                          animate: true,
                          child: Text("\$${itemPrice.toStringAsFixed(2)}"))
                    ],
                  )
              ),
            );
          })

        ],
      )
    );
  }
}
