import 'package:flutter/material.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 25/03/25
/// @Message : [ContactIndividualScreen]
///
/// The `ContactIndividualScreen` class provides for displaying list of e contact
///
/// Responsibilities:
/// To display list of different contacts

///
class ContactIndividualScreen extends StatefulWidget {
  MessageCubit messageCubit;
  MessageState state;

  ContactIndividualScreen(this.state, this.messageCubit, {super.key});

  @override
  State<ContactIndividualScreen> createState() =>
      _ContactIndividualScreenState();
}

class _ContactIndividualScreenState extends State<ContactIndividualScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.state.myListingItem == null ||
            widget.state.myListingItem?.isEmpty == true
        ? Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(AppConstants.noItemsStr,
                  style: FontTypography.defaultTextStyle),
            ),
          )
        : Container(
      padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.only(bottom: 64),
            // color: AppColors.primaryColor,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.state.myListingItem?.length ?? 0,
              itemBuilder: (context, index) {
                final contact = widget.state.myListingItem?[index];
                return Container(
                  color: AppColors.whiteColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: contact?.profilepic != null &&
                                            contact!.profilepic!.isNotEmpty
                                        ? LoadNetworkImageProvider
                                            .getNetworkImageProvider(
                                                url: contact.profilepic!)
                                        : null, // Null if no image
                                    child: (contact?.profilepic == null ||
                                            contact!.profilepic!.isEmpty)
                                        ? const Icon(Icons.person_2, size: 30)
                                        : null, // Show icon only if no image
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      contact?.name??'',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FontTypography.subTextBoldStyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (contact?.isBlockedByUser == false) {
                                  AppRouter.push(
                                      AppRoutes.myContactProfileScreenRoute,
                                      args: {
                                        ModelKeys.contactId: contact?.contactUserId,
                                      });
                                }else{
                                  await AppUtils.showAlertDialog(
                                    context,
                                    title: AppConstants.appTitleStr,
                                    description: AppConstants.blockProfileErrorMessage,
                                    confirmationText: AppConstants.okStr,
                                    onOkPressed: () {
                                      navigatorKey.currentState?.pop();
                                    },
                                  );
                                }
                              },
                              child: ReusableWidgets.createSvg(
                                size: 22,
                                path: AssetPath.contactIcon,
                              ),
                            ),
                            const SizedBox(width: 22),
                            InkWell(
                              onTap: () {
                                AppRouter.push(AppRoutes.messageChatScreenRoute, args: {
                                  ModelKeys.receiverId: contact?.contactUserId,
                                  ModelKeys.senderName: contact?.name,
                                  ModelKeys.lastMessageId: 0,
                                  ModelKeys.itemListId: 0,
                                  ModelKeys.messageListId: widget.state.myListingItem?[index].messageListId,
                                });
                              },
                              child: ReusableWidgets.createSvg(
                                  size: 22, path: AssetPath.messageContactIcon),
                            ),
                            const SizedBox(width: 22),
                            InkWell(
                              onTap: () {
                                ReusableWidgets.showConfirmationDialog(
                                    AppConstants.appTitleStr, // Dialog title
                                    AppConstants.areYouSureDeleteContactStr,
                                    () async {
                                  navigatorKey.currentState?.pop();
                                  widget.messageCubit
                                      .onDeleteClick(itemId: contact?.contactId);
                                });
                              },
                              child: ReusableWidgets.createSvg(
                                size: 22,
                                path: AssetPath.deleteAccountIcon,
                                color: AppColors.deleteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: AppColors.extraLightGreyColor,
                        thickness: 0.1,
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }
}
