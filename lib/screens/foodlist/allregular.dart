import 'package:flutter/cupertino.dart';

class AllRegular extends StatefulWidget {
  const AllRegular({Key? key}) : super(key: key);

  @override
  State<AllRegular> createState() => _AllRegularState();
}

class _AllRegularState extends State<AllRegular> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Food list",
        middle: Text("Regular Dishes"),
      ),
      child: Center(
          child: Text("All Regular")
      ),
    );
  }
}