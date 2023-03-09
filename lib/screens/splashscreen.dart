import 'dart:async';
import 'package:abiskitchen/screens/login/loginview.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import '../global.dart';
import 'bottomnavigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = GetStorage();
  bool hasToken = false;
  late String uToken = "";

  @override
  void initState() {
    super.initState();
    if (storage.read("token") != null) {
      uToken = storage.read("token");
      setState(() {
        hasToken = true;
      });
    }
    if (hasToken) {
      Timer(const Duration(seconds: 7),
          () => Navigator.pushAndRemoveUntil(context,
              CupertinoPageRoute(builder: (_) {
                return const MyHomePage();
              }), (route) => false));
    } else {
      Timer(const Duration(seconds: 7),
              () => Navigator.pushAndRemoveUntil(context,
              CupertinoPageRoute(builder: (_) {
                return const LoginView();
              }), (route) => false));
    }

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: CupertinoColors.black,
            image: DecorationImage(
                image: AssetImage("assets/images/food.jpg"), fit: BoxFit.cover),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.only(bottom:30.0),
              child: Center(
                child: Text("Abi's Kitchen",style: TextStyle(fontWeight:FontWeight.bold,fontSize:50,color:defaultColor)),
              ),
            ),
            SizedBox(
              width: 250.0,
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Bobbers',
                    fontWeight: FontWeight.bold),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText(
                        "Food you can't resists",
                      speed: const Duration(milliseconds:100)
                    ),
                  ],
                ),
              ),
            )
          ])),
    );
  }
}
