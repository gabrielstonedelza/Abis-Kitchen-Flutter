import 'package:flutter/cupertino.dart';

class FoodMenu extends StatelessWidget {
  final selected;
  final Function callback;
  final food;

  FoodMenu(this.selected, this.callback,this.food);

  @override
  Widget build(BuildContext context) {
    return Text("List");
  }
}
