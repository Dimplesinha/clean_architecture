import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';

class AccountTypeWidget extends StatelessWidget {
  final AddSwitchAccountLoadedState state;
  final AddSwitchAccountCubit addSwitchAccountCubit;

  const AccountTypeWidget({super.key, required this.state, required this.addSwitchAccountCubit});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<int>(
        isExpanded: true,
        hint: Text(AppConstants.accountType, style: FontTypography.textFieldHintStyle),
        customButton: Container(
          height: AppConstants.constTxtFieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(constBorderRadius),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Text(
                  AppConstants.accountTypeOptions[state.accountType] ?? AppConstants.accountType,
                  style: (AppConstants.accountTypeOptions[state.accountType]?.isEmpty ?? true)
                      ? FontTypography.textFieldHintStyle
                      : FontTypography.defaultTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(AssetPath.iconDropDown),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(color: AppColors.backgroundColor)),
        items: AppConstants.accountTypeOptions.entries.map((entry) {
          return DropdownMenuItem<int>(
            value: entry.key,
            child: Row(
              children: [
                // Add icon based on the entry key
                SvgPicture.asset(
                  entry.key == 1 ? AssetPath.personalAccountTypeIcon : AssetPath.businessAccountTypeIcon,
                  width: 12, // Adjust icon size as needed
                  height: 12,
                ),
                const SizedBox(width: 10), // Space between icon and text
                Text(
                  entry.value, // Display the corresponding string
                  style: FontTypography.textFieldBlackStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
        value: state.accountType,
        onChanged: (int? value) {
          addSwitchAccountCubit.onAccountTypeChange(accountType: value ?? 0);
        },
      ),
    );
  }
}
