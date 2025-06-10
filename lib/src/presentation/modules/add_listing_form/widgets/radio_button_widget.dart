import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';

class RadioButtonWidget extends StatelessWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;
  final void Function()? onChangeAdditionalMethod;
  final String formConstantKey;
  final String title;

  const RadioButtonWidget({
    super.key,
    this.onChangeAdditionalMethod,
    required this.state,
    required this.formConstantKey,
    required this.addListingFormCubit,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      child: InkWell(
        onTap: () {
          addListingFormCubit.onFieldsValueChanged(key: formConstantKey, value: title);
          onChangeAdditionalMethod?.call();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16.0,
              width: 16.0,
              child: Radio<String>(
                value: title,
                groupValue: state.formDataMap?[formConstantKey],
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  addListingFormCubit.onFieldsValueChanged(key: formConstantKey, value: value ?? '');
                  onChangeAdditionalMethod?.call();
                },
              ),
            ),
            sizedBox5Width(),
            Text(title, style: FontTypography.defaultTextStyle),
          ],
        ),
      ),
    );
  }
}
class RadioButton extends StatelessWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;
  final void Function()? onChangeAdditionalMethod;
  final String formConstantKey;
  final String title;
  final String value;

  const RadioButton({
    super.key,
    this.onChangeAdditionalMethod,
    required this.state,
    required this.formConstantKey,
    required this.addListingFormCubit,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      child: InkWell(
        onTap: () {
          addListingFormCubit.onFieldsValueChanged(key: formConstantKey, value: value);
          onChangeAdditionalMethod?.call();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16.0,
              width: 16.0,
              child: Radio<String>(
                value: value,
                groupValue: state.formDataMap?[formConstantKey],
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  addListingFormCubit.onFieldsValueChanged(key: formConstantKey, value: value ?? '');
                  onChangeAdditionalMethod?.call();
                },
              ),
            ),
            sizedBox5Width(),
            Text(title, style: FontTypography.defaultTextStyle),
          ],
        ),
      ),
    );
  }
}