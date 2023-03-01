import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        String? title = message.notification!.title;
        String? body = message.notification!.body;
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 123,
            channelKey: "call_channel",
            color: Colors.white,
            title: title,
            body: body,
            category: NotificationCategory.Call,
            wakeUpScreen: true,
            fullScreenIntent: true,
            autoDismissible: false,
            backgroundColor: Colors.orange,
          ),
          actionButtons: [
            // NotificationActionButton(
            //     key: 'ACCEPT',
            //     label: 'Accept call',
            //     color: Colors.green,
            //     autoDismissible: true),
            NotificationActionButton(
              key: 'REJECT',
              label: 'Tushundim',
              color: Colors.red,
              autoDismissible: true,
            ),
          ],
        );
        AwesomeNotifications().actionStream.listen((event) {
          if (event.buttonKeyPressed == "REJECT") {
            print("Call Reject");
          } else if (event.buttonKeyPressed == "ACCEPT") {
            print("Call accept");
          } else {
            print('clict on notifications');
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                print("Tokin ishladi");
                String? token = await FirebaseMessaging.instance.getToken();
                print('Token: R$token');
              },
              child: Container(
                width: 100,
                height: 40,
                color: Colors.cyan,
                child: const Center(child: Text("Get Token")),
              ),
            ),
            GestureDetector(
              onTap: () async {
                print(
                  "Sent push ishladi",
                );

                sendPushNotification();
              },
              child: Container(
                width: 100,
                height: 40,
                color: Colors.cyan,
                child: const Center(
                    child: Text(
                  "Sent push notifications",
                  textAlign: TextAlign.center,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendPushNotification() async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAArKEz7Ic:APA91bG81mTgKC1riJ7vv1cn18L_mUZrlJLlrcYYtR6dAvV-rIs8X_RwdTmJ6CTE0pnu_lmolbCtP6JNqksi6p2k0Qb370n4F37Jhzctsw9lyr0BMIgpAMnaaIlN9lGFM0YKJHeDEUex',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Qayerda san',
              'title': 'Abdulloh',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
            },
            'to':
                "RegRRGAXCQ9-J5Ov1p3aFYQ:APA91bEGP27L8Nn7bUeD8doYVqEsGDiYQ-tkQe9EcS2egj_XLnrilhlmAYZd6eIpNVDKeFa_BnKbHeSkmoKLhoN6vXSARViARi6p_iKmD65nlJzUeaJuBV0Ow8hd4gapr2jPFnRJeieo"
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }
}
