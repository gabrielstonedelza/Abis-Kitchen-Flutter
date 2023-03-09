import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controllers/userprofile/profilecontroller.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileController profileController = Get.find();
  var items;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar:const CupertinoNavigationBar(
          leading: Text("Profile",style: TextStyle(fontWeight: FontWeight.bold,)),
        ),
      child: GetBuilder<ProfileController>(builder:(controller){
          return ListView.builder(
            itemCount: controller.profileDetails != null ? controller.profileDetails.length : 0,
            itemBuilder: (context,index){
              items = controller.profileDetails[index];
              return Column(
                children: [
                  Text(items['get_username'])
                ],
              );
            },
          );
      }),
    );
  }
}