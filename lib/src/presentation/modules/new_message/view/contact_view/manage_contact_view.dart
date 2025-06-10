import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/new_message/cubit/new_message_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12/09/24
/// @Message : [ManageContactScreen]
///
/// The `ManageContactScreen` class provides for displaying list of e contact
///
/// Responsibilities:
/// To display list of different contacts
class ManageContactScreen extends StatefulWidget {
  final NewMessageCubit newMessageCubit;

  const ManageContactScreen({super.key, required this.newMessageCubit});

  @override
  State<ManageContactScreen> createState() => _ManageContactScreenState();
}

class _ManageContactScreenState extends State<ManageContactScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
          widget.newMessageCubit.hasNextPage) {
        widget.newMessageCubit.fetchContactList(isRefresh: false);
      }
    });
    widget.newMessageCubit.initContacts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMessageCubit, NewMessageState>(
      bloc: widget.newMessageCubit,
      builder: (context, state) {
        if (state is NewMessageLoadedState) {
          return state.loader == false
              ? state.myListingItem == null || state.myListingItem?.isEmpty == true
              ? Center(
            child: Text(AppConstants.noItemsStr, style: FontTypography.defaultTextStyle),
          )
              : RefreshIndicator(
            backgroundColor: AppColors.whiteColor,
            color: AppColors.primaryColor,
            onRefresh: () async {
              // Used for clear text on pull to refresh in listings.
              if (widget.newMessageCubit.searchTxtController.text.isNotEmpty) {
                widget.newMessageCubit.searchTxtController.text = '';
              }
              //Used to identify current page.
              widget.newMessageCubit.contactCurrentPage = 1;
              await widget.newMessageCubit.fetchContactList(isRefresh: true, isSwipe: true);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // <-- Important
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    itemCount: state.myListingItem?.length ?? 0,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final contact = state.myListingItem?[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(width: 0.1, color: AppColors.extraLightGreyColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              // User profile picture
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child:
                                  LoadProfileImage(url: contact?.profilepic),
                                ),
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
                              InkWell(
                                onTap: () async {
                                  if (contact?.isBlockedByUser == false) {
                                    AppRouter.push(AppRoutes.myContactProfileScreenRoute, args: {
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
                                    ModelKeys.messageListId: 0,
                                  });
                                },
                                  child: ReusableWidgets.createSvg(size: 22, path: AssetPath.messageContactIcon)
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
              : const Center(child: CircularProgressIndicator());
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}