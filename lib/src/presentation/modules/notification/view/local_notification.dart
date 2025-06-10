import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/presentation/modules/notification/helper/local_notification_helper.dart';

class LocalNotification extends StatelessWidget {
  const LocalNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 16, fontFamily: AppConstants.fontFamilyDMSans),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NotificationHelper.showNotification();
              },
              child: const Text('Show Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                NotificationHelper.scheduleNotification();
              },
              child: const Text('Schedule Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
