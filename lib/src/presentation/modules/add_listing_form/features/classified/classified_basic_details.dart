import 'package:flutter/material.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_utils.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/drop_down_constants.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/app_utils.dart';

class ClassifiedBasicDetails extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;
  final CategoriesListResponse? category;

  const ClassifiedBasicDetails({
    super.key,
    required this.addListingFormCubit,
    required this.state,
    required this.category,
  });

  @override
  State<ClassifiedBasicDetails> createState() => _ClassifiedBasicDetailsState();
}

class _ClassifiedBasicDetailsState extends State<ClassifiedBasicDetails> {
  final searchController = TextEditingController();
  final selectCurrencyController = TextEditingController();
  List<Countries>? currencyList;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      selectCurrencyController.text = selectCurrencyController.text;
      widget.addListingFormCubit.businessListDisplay();
      widget.addListingFormCubit.communityListDisplay();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _classifiedTypeDropdown(),
          _typeDropDown(),
          _businessName(),
          _communityOrganization(),
          LabelText(
            title: AddListingFormConstants.itemName,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.itemNameType,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.itemName],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.itemName, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.itemDescription,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            height: 100,
            topPadding: 12,
            maxLines: 5,
            hintTxt: AddListingFormConstants.itemDescription,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.itemDescription],
            onChanged: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.itemDescription, value: value);
            },
          ),
        ],
      ),
    );
  }

  Widget _businessName() {
    String? businessName = widget.state.formDataMap?[AddListingFormConstants.businessName] ?? '';
    var list = widget.state.businessListResult;
    CommonDropdownModel? selectedItem = AddListingUtils.getBusinessDropdownItem(businessName, list);

    return Visibility(
      visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr &&
          widget.state.formDataMap?[AddListingFormConstants.businessCommunityTypeKey] == AppConstants.businessStr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(
            title: AddListingFormConstants.businessName,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          DropDownWidget2(
            hintText: AddListingFormConstants.businessName,
            items: widget.state.businessListResult
                ?.map((item) => CommonDropdownModel(id: item.businessProfileId ?? 0, name: item.businessName ?? ''))
                .toList(),
            dropDownValue: selectedItem,
            dropDownOnChange: (CommonDropdownModel? value) {
              widget.addListingFormCubit.onFieldsValueChanged(
                keysValuesMap: {
                  AddListingFormConstants.businessName: value?.name ?? '',
                  AddListingFormConstants.businessProfileId: value?.id.toString(),
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _typeDropDown() {
    return Visibility(
      visible: AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(
            title: AddListingFormConstants.businessOrCommunityOrganization,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          DropDownWidget(
            hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.businessOrCommunityOrganization}',
            items: const [
              AppConstants.businessStr,
              AppConstants.communityOrganization,
            ],
            displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.businessCommunityTypeKey],
            dropDownValue: widget.state.formDataMap?[AddListingFormConstants.businessCommunityTypeKey] != ''
                ? (widget.state.formDataMap?[AddListingFormConstants.businessCommunityTypeKey])
                : null,
            dropDownOnChange: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(keysValuesMap: {
                AddListingFormConstants.businessCommunityTypeKey: value ?? '',
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _communityOrganization() {
    String? communityName = widget.state.formDataMap?[AddListingFormConstants.community] ?? '';
    var list = widget.state.communityListResult;
    CommonDropdownModel? selectedCommunity = AddListingUtils.getCommunityDropdownItem(communityName, list);

    bool visible = widget.state.formDataMap?[AddListingFormConstants.businessCommunityTypeKey] ==
            AppConstants.communityOrganization ||
        AppUtils.loginUserModel?.accountTypeValue == AppConstants.personalStr;

    return Visibility(
      visible: visible,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(
            title: AddListingFormConstants.communityOrganization,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          DropDownWidget2(
            hintText: AddListingFormConstants.communityOrganization,
            items: widget.state.communityListResult
                ?.map((item) => CommonDropdownModel(id: item.communityId ?? 0, name: item.title ?? ''))
                .toList(),
            dropDownValue: selectedCommunity,
            dropDownOnChange: (CommonDropdownModel? value) {
              widget.addListingFormCubit.onFieldsValueChanged(
                keysValuesMap: {
                  AddListingFormConstants.community: value?.name ?? '',
                  AddListingFormConstants.communityId: value?.id.toString(),
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _classifiedTypeDropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(title: AddListingFormConstants.classifiedType, textStyle: FontTypography.subTextStyle),
        DropDownWidget(
          items: DropDownConstants.classifiedListDropDownList.values.toList(),
          dropDownOnChange: (value) {
            widget.addListingFormCubit
                .onFieldsValueChanged(key: AddListingFormConstants.classifiedType, value: value ?? '');
          },
          hintText: AddListingFormConstants.chooseClassifiedTypeStr,
          displaySelectedItem: widget.state.formDataMap?[AddListingFormConstants.classifiedType] ??
              AddListingFormConstants.chooseClassifiedTypeStr,
          dropDownValue: widget.state.formDataMap?[AddListingFormConstants.classifiedType],
        ),
      ],
    );
  }
}
