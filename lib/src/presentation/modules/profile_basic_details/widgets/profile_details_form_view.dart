import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/app_btn.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/cubit/profile_basic_details_cubit.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/app_utils.dart';

class ProfileDetailsFormView extends StatelessWidget {
  final LoginModel profileBasicDetails;
  final ProfileBasicDetailsCubit profileBasicDetailsCubit;

  const ProfileDetailsFormView({
    super.key,
    required this.profileBasicDetails,
    required this.profileBasicDetailsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ReadOnlyTextField(
            title: AppConstants.accountType,
            value: '${profileBasicDetails.accountTypeValue??''} ',
          ),
          ReadOnlyTextField(
            title: AppConstants.nameStr,
            value:
                '${profileBasicDetails.firstName??''} ${profileBasicDetails.lastName??''}',
          ),
          ReadOnlyTextField(
              title: AppConstants.yearOfBirthStr,
              value: profileBasicDetails.getBirthYear),
          ReadOnlyTextField(
            title: AppConstants.genderStr,
            value: AppUtils.getGenderFromCode(profileBasicDetails.gender ?? ''),
          ),
          const Spacer(),
          SizedBox(
            width: 185,
            child: AppButton(
              function: () {
                AppRouter.push(AppRoutes.profilePersonalDetailsScreenRoute,
                    args: {
                      ModelKeys.isFromProfile: false,
                      ModelKeys.firstName: profileBasicDetails.firstName??'',
                      ModelKeys.lastName: profileBasicDetails.lastName??'',
                      ModelKeys.birthYear: profileBasicDetails.birthYear ?? '',
                      ModelKeys.gender: profileBasicDetails.gender??''
                    });
              },
              title: AppConstants.nextStr,
            ),
          ),
          sizedBox30Height()
        ],
      ),
    );
  }
}
