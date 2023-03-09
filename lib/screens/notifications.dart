import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/notifications/notificationcontroller.dart';
import 'bottomnavigation.dart';
import 'foodlist/foodlist.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationController notificationsController = Get.find();
  final storage = GetStorage();

  late String username = "";
  late String uToken = "";
  var items;

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
    notificationsController.readNotifications(uToken);

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        leading: Text("Alerts",style: TextStyle(fontWeight: FontWeight.bold,)),
      ),
      child: GetBuilder<NotificationController>(builder:(controller){
        return ListView.builder(
          itemCount: controller.notifications != null ? controller.notifications.length :0,
          itemBuilder: (context,index){
            items = controller.notifications[index];
            return Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              child: Padding(
                padding: const EdgeInsets.only(top:8.0,bottom:8.0),
                child: ListTile(
                  onTap: (){
                    if(controller.notifications[index]['notification_title'] == "Food Menu Updated"){
                      Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context){
                        return const FoodList();
                      }),ModalRoute.withName('/'));
                    }
                  },
                  title: Text(items['notification_title'],style: const TextStyle(fontWeight: FontWeight.bold,)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:18.0),
                          child: Text(items['notification_message']),
                        ),
                        Text(items['date_created'].toString().split("T").first),
                      ],
                    ),
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
