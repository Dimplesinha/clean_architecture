import 'package:flutter/foundation.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/features/required_fields/required_fields.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/app_utils.dart';

class PromoBasicDetailsView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const PromoBasicDetailsView({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<PromoBasicDetailsView> createState() => _PromoBasicDetailsViewState();
}

class _PromoBasicDetailsViewState extends State<PromoBasicDetailsView> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  void initState() {
    startDateController.text = '';
    endDateController.text = '';
    widget.addListingFormCubit.getCategoryType();
    handleBusinessCommunityType();
    super.initState();
  }

  @override
  void dispose() {
    startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddListingFormCubit, AddListingFormLoadedState>(
      bloc: widget.addListingFormCubit,
      builder: (context, state) {
        var startDate =
            AppUtils.formatDate(state.startDate ?? state.formDataMap?[AddListingFormConstants.startDate] ?? '');
        startDateController.text = startDate!;

        var endDate = AppUtils.formatDate(state.endDate ?? state.formDataMap?[AddListingFormConstants.endDate] ?? '');
        endDateController.text = endDate!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _typeDropDown(),
              _businessName(),
              _communityOrganization(),
              _categoryType(),

              LabelText(
                title: AddListingFormConstants.promotionName,
                textStyle: FontTypography.subTextStyle,
              ),
              AppTextField(
                hintTxt: AddListingFormConstants.typePromotionName,
                initialValue: widget.state.formDataMap?[AddListingFormConstants.promotionName],
                onChanged: (value) {
                  widget.addListingFormCubit
                      .onFieldsValueChanged(key: AddListingFormConstants.promotionName, value: value);
                },
              ),
              LabelText(
                title: AddListingFormConstants.promotionDescription,
                textStyle: FontTypography.subTextStyle,
              ),
              AppTextField(
                hintTxt: AddListingFormConstants.promotionDescription,
                initialValue: widget.state.formDataMap?[AddListingFormConstants.promotionDescription],
                height: 130,
                maxLines: 6,
                topPadding: 12,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  widget.addListingFormCubit
                      .onFieldsValueChanged(key: AddListingFormConstants.promotionDescription, value: value);
                },
              ),

              /// Promo Duration - Start and End Dates
              LabelText(
                title: AddListingFormConstants.promoDuration,
                textStyle: FontTypography.subTextStyle,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        widget.addListingFormCubit.openDatePicker(
                          context,
                          isFromStartDate: true,
                          hasStartEndDate: true,
                        );
                      },
                      child: AppTextField(
                        controller: startDateController,
                        isReadOnly: true,
                        isEnable: false,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: ReusableWidgets.createSvg(path: AssetPath.calendarIcon),
                        ),
                        hintTxt: AppUtils.formatDate(state.startDate ?? AddListingFormConstants.startDate),
                        hintStyle: state.startDate != null
                            ? FontTypography.textFieldBlackStyle
                            : FontTypography.textFieldHintStyle,
                        initialValue: null,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                  sizedBox20Width(),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        widget.addListingFormCubit.openDatePicker(
                          context,
                          isFromStartDate: false,
                          hasStartEndDate: true,
                        );
                      },
                      child: AppTextField(
                        controller: endDateController,
                        isReadOnly: true,
                        isEnable: false,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: ReusableWidgets.createSvg(path: AssetPath.calendarIcon),
                        ),
                        hintTxt: AppUtils.formatDate(state.endDate ??
                            state.formDataMap?[AddListingFormConstants.endDate] ??
                            AddListingFormConstants.endDate),
                        hintStyle: state.endDate != null
                            ? FontTypography.textFieldBlackStyle
                            : FontTypography.textFieldHintStyle,
                        initialValue: null,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ],
              ),
              LabelText(
                title: AddListingFormConstants.promoUrl,
                textStyle: FontTypography.subTextStyle,
                isRequired: false,
              ),
              AppTextField(
                hintTxt: AddListingFormConstants.enterYourURL,
                initialValue: widget.state.formDataMap?[AddListingFormConstants.promoUrl],
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
                textCapitalization: TextCapitalization.none,
                onChanged: (value) {
                  widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.promoUrl, value: value);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _businessName() {
    String? businessName = widget.state.formDataMap?[AddListingFormConstants.businessName] ?? '';
    CommonDropdownModel? selectedItem;
    try {
      var list = widget.state.businessListResult;
      list = list?.where((item) => item.businessName == businessName).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.businessProfileId ?? 0, name: item?.businessName ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return Visibility(
      visible: (AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr ||
              widget.state.formDataMap?[AddListingFormConstants.accountType] == AppConstants.businessStr) &&
          widget.state.formDataMap?[AddListingFormConstants.businessCommunityTypeKey] == AppConstants.businessStr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(
            title: AddListingFormConstants.businessName,
            textStyle: FontTypography.subTextStyle,
          ),
          DropDownWidget2(
            hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.businessName}',
            items: widget.state.businessListResult
                ?.map(
                  (item) => CommonDropdownModel(id: item.businessProfileId ?? 0, name: item.businessName ?? ''),
                )
                .toList(),
            dropDownValue: selectedItem,
            dropDownOnChange: (CommonDropdownModel? value) {
              handleBusinessList();
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

  Widget _categoryType() {
    String? categoryTypeName = widget.state.formDataMap?[AddListingFormConstants.promoCategory] ?? '';
    CommonDropdownModel? selectedItem;
    try {
      var list = widget.state.categoryType?.result;
      list = list?.where((item) => item.promoCategoryName == categoryTypeName).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.promoCategoryId ?? 0, name: item?.promoCategoryName ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.categoryType,
          textStyle: FontTypography.subTextStyle,
        ),
        DropDownWidget2(
          hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.categoryType}',
          items: widget.state.categoryType?.result
              ?.map(
                (item) => CommonDropdownModel(id: item.promoCategoryId ?? 0, name: item.promoCategoryName ?? ''),
              )
              .toList(),
          dropDownValue: selectedItem,
          dropDownOnChange: (CommonDropdownModel? value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              keysValuesMap: {
                AddListingFormConstants.promoCategory: value?.name ?? '',
                AddListingFormConstants.promoCategoryId: value?.id.toString(),
              },
            );
          },
        ),
      ],
    );
  }

  Widget _typeDropDown() {
    return Visibility(
      visible: (AppUtils.loginUserModel?.accountTypeValue == AppConstants.businessStr ||
          widget.state.formDataMap?[AddListingFormConstants.accountType] == AppConstants.businessStr),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(
            title: AddListingFormConstants.businessOrCommunityOrganization,
            textStyle: FontTypography.subTextStyle,
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
              handleBusinessCommunityType();
            },
          ),
        ],
      ),
    );
  }

  Widget _communityOrganization() {
    String? communityName = widget.state.formDataMap?[AddListingFormConstants.community] ?? '';
    CommonDropdownModel? selectedCommunity;
    try {
      var list = widget.state.communityListResult;
      list = list?.where((item) => item.title == communityName).toList();
      if (list?.isNotEmpty ?? false) {
        var communityList = widget.state.communityListResult;
        communityList = communityList?.where((item) => item.title == communityName).toList();
        if (communityList?.isNotEmpty ?? false) {
          var item = communityList?.first;
          selectedCommunity = CommonDropdownModel(id: item?.communityId ?? 0, name: item?.title ?? '');
        }
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
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
          ),
          DropDownWidget2(
            hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.communityOrganization}',
            items: widget.state.communityListResult
                ?.map(
                  (item) => CommonDropdownModel(id: item.communityId ?? 0, name: item.title ?? ''),
                )
                .toList(),
            dropDownValue: selectedCommunity,
            dropDownOnChange: (CommonDropdownModel? value) {
              handleCommunityList();
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

  void handleCommunityList() {
    widget.state.formDataMap?.remove(AddListingFormConstants.businessName);
    widget.state.formDataMap?.remove(AddListingFormConstants.businessTypeId);
    RequiredFieldsConstants.promoBasicDetailsRequiredFields = RequiredFieldsConstants.promoBasicDetailsRequiredFields
      ..addAll(
        {AddListingFormConstants.community: null},
      );
    RequiredFieldsConstants.promoBasicDetailsRequiredFields = RequiredFieldsConstants.promoBasicDetailsRequiredFields
      ..remove(
        AddListingFormConstants.businessName,
      );
  }

  void handleBusinessList() {
    widget.state.formDataMap?.remove(AddListingFormConstants.community);
    widget.state.formDataMap?.remove(AddListingFormConstants.communityId);
    RequiredFieldsConstants.promoBasicDetailsRequiredFields = RequiredFieldsConstants.promoBasicDetailsRequiredFields
      ..addAll(
        {AddListingFormConstants.businessName: null},
      );
    RequiredFieldsConstants.promoBasicDetailsRequiredFields = RequiredFieldsConstants.promoBasicDetailsRequiredFields
      ..remove(
        AddListingFormConstants.community,
      );
  }

  void handleBusinessCommunityType() {
    if (widget.state.formDataMap?[AddListingFormConstants.businessCommunityTypeKey] == AppConstants.businessStr) {
      RequiredFieldsConstants.promoBasicDetailsRequiredFields = RequiredFieldsConstants.promoBasicDetailsRequiredFields
        ..addAll(
          {AddListingFormConstants.businessName: null},
        );
      RequiredFieldsConstants.promoBasicDetailsRequiredFields = RequiredFieldsConstants.promoBasicDetailsRequiredFields
        ..remove(
          AddListingFormConstants.community,
        );
    } else {
      RequiredFieldsConstants.promoBasicDetailsRequiredFields = RequiredFieldsConstants.promoBasicDetailsRequiredFields
        ..addAll(
          {AddListingFormConstants.community: null},
        );
      RequiredFieldsConstants.promoBasicDetailsRequiredFields = RequiredFieldsConstants.promoBasicDetailsRequiredFields
        ..remove(
          AddListingFormConstants.businessName,
        );
    }
  }
}
