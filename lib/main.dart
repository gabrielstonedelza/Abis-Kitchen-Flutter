import 'package:abiskitchen/global.dart';
import 'package:abiskitchen/screens/cart.dart';
import 'package:abiskitchen/screens/favorites.dart';
import 'package:abiskitchen/screens/foodlist/foodlist.dart';
import 'package:abiskitchen/screens/login/loginview.dart';
import 'package:abiskitchen/screens/profile.dart';
import 'package:abiskitchen/screens/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import 'controllers/foodlist/foodlistcontroller.dart';
import 'controllers/login/logincontroller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  Get.put(LoginController());
  Get.put(FoodListController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetCupertinoApp(
      debugShowCheckedModeBanner: false,
      popGesture: true,
      defaultTransition: Transition.cupertino,
      theme: CupertinoThemeData(
          brightness: Brightness.light, primaryColor: primaryColor),
      home: SplashScreen(),
    );
  }
}


