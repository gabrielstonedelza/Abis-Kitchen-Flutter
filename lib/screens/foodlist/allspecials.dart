import 'package:flutter/cupertino.dart';

class AllSpecials extends StatefulWidget {
  const AllSpecials({Key? key}) : super(key: key);

  @override
  State<AllSpecials> createState() => _AllSpecialsState();
}

class _AllSpecialsState extends State<AllSpecials> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Food list",
        middle: Text("Special Dishes"),
      ),
      child: Center(
        child: Text("All Specials")
      ),
    );
  }
}