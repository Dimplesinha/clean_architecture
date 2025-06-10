import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/assets_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';


/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12/09/24
/// @Message : [ContactRequestScreen]
///
/// The `ContactRequestScreen` class provides for displaying list of  contact requests
///
/// Responsibilities:
/// To display list of different contacts requests
///
class ContactRequestScreen extends StatefulWidget {
  const ContactRequestScreen({super.key});

  @override
  State<ContactRequestScreen> createState() => _ContactRequestScreenState();
}

class _ContactRequestScreenState extends State<ContactRequestScreen> {
  MessageCubit messageCubit = MessageCubit();

  @override
  void initState() {
    super.initState();
    messageCubit = MessageCubit();
    if(AppUtils.loginUserModel?.uuid != null) {
      messageCubit.fetchItems();

    }
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
              itemCount: state.messages.length ,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return Container(
                  height: 85,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border: Border.all(color: AppColors.borderColor,width: 0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          message.userName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontTypography.subTextBoldStyle,
                        ),
                        const Spacer(),
                        ReusableWidgets.createSvg(path: AssetPath.crossIcon,size: 28),
                        const SizedBox(width: 20),
                        ReusableWidgets.createSvg(path: AssetPath.tickIcon,size: 28),
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
