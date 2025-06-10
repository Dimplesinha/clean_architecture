import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/enquiry_model.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11-09-2024
/// @Message : [EnquiriesScreen]

/// This `EnquiriesScreen` is displayed when listing statistics selectedIndex is 2.
/// This view has list of enquiry on the account.
/// It displays details of enquirer name, city, on what time,and what type of enquiry it was.
/// There are 2 ways of enquiry added 1 is message and other is phone.
///
/// Responsibilities:
/// - Displays list of enquiries.
/// - Has custom container with basic details of enquirer.
class EnquiriesScreen extends StatefulWidget {
  final List<StatisticsEnquiryItem> enquiryData;
  final int itemId;

  const EnquiriesScreen({super.key, required this.enquiryData, required this.itemId});

  @override
  State<EnquiriesScreen> createState() => _EnquiriesScreenState();
}

class _EnquiriesScreenState extends State<EnquiriesScreen> {
  @override
  void initState() {
    super.initState();
  }

  ///Layout Manager for mobile view and tab view
  @override
  Widget build(BuildContext context) {
    var enquiriesList = widget.enquiryData;
    return LayoutBuilder(builder: (context, constraints) {
      return enquiriesList.isNotEmpty
          ? _mobileView(enquiriesList)
          : Text(
              'No enquiries found',
              style: FontTypography.subTextStyle,
            );
    });
  }

  /// Mobile view has listview builder for displaying all items of list in custom container in it.
  Widget _mobileView(List<StatisticsEnquiryItem> enquiriesList) {
    return ListView.builder(
      itemCount: widget.enquiryData.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var item = enquiriesList[index];
        return Column(
          children: [
            _contactContainer(
              name: item.userName ?? '',
              city: item.location ?? '',
              timeAgo: item.sendAt ?? '',
              enquiryType: AppConstants.messagesStr,
              profilePic: item.profilePic ?? '',
              receiverId: item.receiverId ?? 0,
              messageListId: item.messageListId ?? 0,
              itemId: widget.itemId,
            ),
            sizedBox20Height(),
          ],
        );
      },
    );
  }

  ///This view has list-tile view in it within container where there is profile pic of enquirer, name, city,type of
  ///contact, and time duration.
  ///It is custom made container called in listview.
  Widget _contactContainer({
    required String name,
    required String city,
    required String? timeAgo,
    required String enquiryType,
    required String profilePic,
    required int receiverId,
    required int messageListId,
    required int itemId,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: AppColors.locationButtonBackgroundColor,
          borderRadius: BorderRadius.circular(constEnquiryContactRadius)),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LoadProfileImage(url: profilePic),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: FontTypography.enquiryNameTxtStyle,
            ),
            InkWell(
              onTap: () {
                if (enquiryType == AppConstants.messagesStr) {
                  AppRouter.push(AppRoutes.messageChatScreenRoute, args: {
                    ModelKeys.receiverId: receiverId,
                    ModelKeys.lastMessageId: 0,
                    ModelKeys.messageListId: messageListId,
                    ModelKeys.itemListId: widget.itemId,
                  });
                }
              },
              child: ReusableWidgets.createSvg(
                  path: enquiryType == AppConstants.messagesStr ? AssetPath.messageOutlineIcon : AssetPath.phoneIcon,
                  color: AppColors.primaryColor,
                  size: 18),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox8Height(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  city,
                  style: FontTypography.enquiryCityTxtStyle,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
                sizedBox5Height(),
                Text(
                  textAlign: TextAlign.right,
                  timeAgo != null ? AppUtils.groupMessageDateAndTime(timeAgo) : '',
                  style: FontTypography.enquiryCityTxtStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
