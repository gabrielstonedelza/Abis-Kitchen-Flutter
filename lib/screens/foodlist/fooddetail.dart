import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodDetail extends StatefulWidget {
  final name;
  final price;
  final pic;
  const FoodDetail({Key? key,required this.name,required this.price,required this.pic}) : super(key: key);

  @override
  State<FoodDetail> createState() => _FoodDetailState(name:this.name,price:this.price,pic:this.pic);
}

class _FoodDetailState extends State<FoodDetail> {
  final name;
  final price;
  final pic;
  _FoodDetailState({required this.name,required this.price,required this.pic});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Food list",
        middle: Text(name),
      ),
      child: ListView(
        children: [
            Hero(tag: "food-pick",
            child: Card(
              elevation: 12,
              child: SizedBox(
                  width: double.infinity,
                  // height: 300,
                  child: Image.network(pic)),
            )
            )
        ],
      )
    );
  }
}
