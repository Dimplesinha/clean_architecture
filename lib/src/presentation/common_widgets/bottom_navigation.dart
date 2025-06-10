///
/// @AUTHOR : Mac OS
/// @DATE : 24/01/24
/// @Message :
///

import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/common_widgets/reusable_widgets.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/utils/signalr_helper.dart'; // Make sure the path is correct

class MyBottomNavigationView extends StatelessWidget {
  final int index;
  final Function(int index) onTap;
  final int unreadMessagesCount; // Add this new parameter

  const MyBottomNavigationView({
    Key? key,
    required this.index,
    required this.onTap,
    this.unreadMessagesCount = 0, // Default to 0 if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: onTap,
        backgroundColor: AppColors.whiteColor,
        selectedIconTheme: IconThemeData(color: AppColors.primaryColor),
        unselectedIconTheme: IconThemeData(color: AppColors.blackColor),
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: FontTypography.defaultTextStyle.copyWith(color: AppColors.primaryColor),
        items: [
          BottomNavigationBarItem(
            icon: ReusableWidgets.createSvg(
              path: AssetPath.homeIcon,
              color: index == 0 ? AppColors.primaryColor : Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ReusableWidgets.createSvg(
              path: AssetPath.myListingIcon,
              color: index == 1 ? AppColors.primaryColor : Colors.black,
            ),
            label: 'My Listing',
          ),
          BottomNavigationBarItem(
            icon: ReusableWidgets.createSvg(
              path: AssetPath.addIcon,
              color: index == 2 ? AppColors.primaryColor : Colors.black,
            ),
            label: 'Add Listing',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none, // Allows the badge to overflow the stack
              alignment: Alignment.center,
              children: [
                ReusableWidgets.createSvg(
                  path: AssetPath.messageIcon,
                  color: index == 3 ? AppColors.primaryColor : Colors.black,
                ),
                StreamBuilder<int>(
                  stream: SignalRHelper.instance.unreadMessageCountStream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    final count = (snapshot.hasData && snapshot.data != null)
                        ? snapshot.data!
                        : unreadMessagesCount;
                    if (count == 0) return const SizedBox.shrink();

                    return Positioned(
                      right: -10,
                      top: -10,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          count > 99 ? '99+' : count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            label: 'Message',
          ),
        ],
      ),
    );
  }
}
