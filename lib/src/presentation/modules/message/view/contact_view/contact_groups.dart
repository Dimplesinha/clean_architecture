import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/assets_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';


/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12/09/24
/// @Message : [ContactGroupsScreen]
///
/// The `ContactGroupsScreen` class provides for displaying list of  contact
///
/// Responsibilities:
/// To display list of different contacts
///
class ContactGroupsScreen extends StatefulWidget {
  const ContactGroupsScreen({super.key});

  @override
  State<ContactGroupsScreen> createState() => _ContactGroupsScreenState();
}

class _ContactGroupsScreenState extends State<ContactGroupsScreen> {
  MessageCubit messageCubit = MessageCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: messageCubit,
      builder: (context, state) {
        return Container(
          color: AppColors.primaryColor,
          child: SafeArea(
            bottom: false,
            child: ListView.builder(
              itemCount: state.messages?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final message = state.messages?[index];
                return Container(
                  height: 85,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border: Border.all(color: AppColors.borderColor,width: 0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 24.0),
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
                        Text(
                          message?.userName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontTypography.subTextBoldStyle,
                        ),
                        const Spacer(),
                        ReusableWidgets.createSvg(size: 22,path: AssetPath.messageContactIcon),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
