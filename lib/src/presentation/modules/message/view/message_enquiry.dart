import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';


/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 11/09/24
/// @Message : [EnquiryView]
///
/// The `EnquiryView` class provides for displaying list of enquiry with search field to search any contact
///
/// Responsibilities:
/// To display list of enquiry from different contacts
/// To display last enquiry
/// To display unread count of message
/// To display last message time
///
class EnquiryView extends StatefulWidget {
  const EnquiryView({super.key});

  @override
  State<EnquiryView> createState() => _EnquiryViewState();
}

class _EnquiryViewState extends State<EnquiryView> {
  MessageCubit messageCubit = MessageCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: messageCubit..fetchItems(),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppTextField(
                height:40 ,
                hintTxt: AppConstants.searchStr,

                suffixIcon: Icon(Icons.search),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.messages?.length ?? 0,
                itemBuilder: (context, index) {
                  final message = state.messages?[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: LoadNetworkImageProvider.getNetworkImageProvider(
                              url:
                              'https://i.natgeofe.com/k/1d33938b-3d02-4773-91e3-70b113c3b8c7/lion-male-roar_square.jpg', // Placeholder image URL
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message?.userName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FontTypography.subTextBoldStyle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  message?.latestMessage?.messageContent ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FontTypography.snackBarButtonStyle.copyWith(
                                    color: AppColors.subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message?.latestMessage?.sentAt != null
                                    ? AppUtils.groupMessageDateAndTime(message?.latestMessage?.sentAt ?? '')
                                    : '',
                                style: FontTypography.listingTimeStyle,
                              ),
                              const SizedBox(height: 6),
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: AppColors.greenColor,
                                child: Center(
                                  child: Text(
                                    '${message?.unreadCount}',
                                    style: FontTypography.tabBarStyle.copyWith(
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
