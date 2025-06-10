import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/presentation/common_widgets/app_bar.dart';
import 'package:workapp/src/presentation/common_widgets/loader_view.dart';
import 'package:workapp/src/presentation/modules/message_chat/cubit/message_chat_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/utils/app_utils.dart';

class MessageInfoScreen extends StatelessWidget {
  final int? messageId;

  const MessageInfoScreen({super.key, required this.messageId});

  @override
  Widget build(BuildContext context) {
    final MessageChatCubit messageChatCubit = MessageChatCubit();
    return BlocBuilder<MessageChatCubit, MessageChatState>(
        bloc: messageChatCubit..messageInfo(messageId: '$messageId'),
    builder: (context, state) {
          var messageInfo = state.messageInfoResult;
      return Stack(
        children: [
          Scaffold(
            appBar: const MyAppBar(
              elevation: 2,
              centerTitle: true,
              title: 'Message Info',
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.extraLightGreyColor,
                  // height: 200,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 40),
                        child: Center(
                          child: Html(
                            data: messageInfo?.messageContent != null ? messageInfo?.messageContent ?? '' : '',
                            shrinkWrap: true,
                            style: {
                              'body': Style(
                                color: AppColors.blackColor,
                              )
                            },
                          ),
                          // child: Text(
                          //   messageInfo?.messageContent != null ? messageInfo?.messageContent ?? '' : '',
                          //   style: FontTypography.subTextBoldStyle.copyWith(fontSize: 18),
                          // ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          messageInfo?.sentAt != null ? AppUtils.groupMessageDateAndTime(messageInfo?.sentAt ?? '') : '',
                          style: FontTypography.defaultTextStyle.copyWith(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    color: AppColors.circleColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Read',
                                  style: FontTypography.insightTextBoldStyle.copyWith(fontSize: 18),
                                ),
                              ),
                              Text(
                                messageInfo?.readTime != null ?
                                AppUtils.groupMessageDateAndTime(messageInfo?.readTime ?? '-') : '-',
                                style: FontTypography.insightTextBoldStyle.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                          Divider(thickness: 1, color: AppColors.extraLightGreyColor),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Delivered',
                                  style: FontTypography.insightTextBoldStyle.copyWith(fontSize: 18),
                                ),
                              ),
                              Text(
                                messageInfo?.deliveredTime != null ?
                                AppUtils.formatTimestamp(messageInfo?.deliveredTime ?? '-') : '-',
                                style: FontTypography.insightTextBoldStyle.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          state.loader == true ? const LoaderView() : const SizedBox.shrink()
        ],
      );
    }
    );
  }
}