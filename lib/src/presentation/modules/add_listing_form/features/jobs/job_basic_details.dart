import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/models/business_profile_detail_resp.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/upload_resume_widget.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class JobBasicDetails extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;
  final String? accountType;

  const JobBasicDetails({super.key, required this.addListingFormCubit, required this.state, this.accountType});

  @override
  State<JobBasicDetails> createState() => _JobBasicDetailsState();
}

class _JobBasicDetailsState extends State<JobBasicDetails> {
  final jobRequirementBulletTxtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // widget.addListingFormCubit.getIndustryType();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _typeDropDown(),
          _businessName(),
          _communityOrganization(),
          LabelText(
            title: AddListingFormConstants.jobTitle,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.enterJobTitle,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.jobTitle],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.jobTitle, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.jobRequirementsBulletPoint,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          AppTextField(
            controller: jobRequirementBulletTxtController,
            suffixIcon: InkWell(
              onTap: () {
                widget.addListingFormCubit.addJobRequirement(
                    jobRequirementBulletPoint: jobRequirementBulletTxtController.text, jobRequirementId: 0);
                jobRequirementBulletTxtController.clear();
              },
              child: Center(
                child: Icon(
                  Icons.add,
                  color: AppColors.jetBlackColor,
                ),
              ),
            ),
            hintTxt: AddListingFormConstants.typeJobRequirement,
          ),
          Visibility(
            visible: widget.state.jobRequirementList?.isNotEmpty ?? false,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              children: widget.state.jobRequirementList?.map((item) => buildChip(item)).toList() ?? [],
            ),
          ),
          _industryType(),
          LabelText(
            title: AddListingFormConstants.description,
            textStyle: FontTypography.subTextStyle,
          ),
          AppTextField(
            height: 130,
            maxLines: 6,
            topPadding: 12,
            textInputAction: TextInputAction.newline,
            hintTxt: AddListingFormConstants.enterJobDescription,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.description],
            onChanged: (value) {
              widget.addListingFormCubit.onFieldsValueChanged(key: AddListingFormConstants.description, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.uploadPositionDescription,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: UploadResumeWidget(
                  label: AddListingFormConstants.uploadResume,
                  addListingFormCubit: widget.addListingFormCubit,
                  state: widget.state,
                ),
              ),
              sizedBox5Width(),
              Flexible(
                child: Text(
                  AddListingFormConstants.uploadResumeMsg,
                  style: FontTypography.uploadMsgTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildChip(JobRequirements item) {
    return Visibility(
      visible: item.isDeleted == false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
        child: Chip(
          side: const BorderSide(color: Colors.transparent),
          label: Text(
            item.jobRequirement ?? '',
            style: FontTypography.snackBarButtonStyle,
          ),
          backgroundColor: AppColors.primaryColor,
          deleteIconColor: AppColors.whiteColor,
          deleteIcon: const Icon(Icons.close, size: 15.0),
          onDeleted: () {
            widget.addListingFormCubit.removeJobRequirement(
              jobRequirementBulletPoint: item.jobRequirement ?? '',
              controlName: ''
            );
          },
        ),
      ),
    );
  }

  Widget _typeDropDown() {
    return Visibility(
      visible: widget.accountType == AppConstants.businessStr,
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
    var communityId = widget.state.fetchBusinessDetails?.businessProfileModel?.communityId;
    if (communityId != null) {
      communityName = widget.state.fetchBusinessDetails?.businessProfileModel?.communityName;
      widget.addListingFormCubit.onFieldsValueChanged(
        keysValuesMap: {
          AddListingFormConstants.community: communityName ?? '',
          AddListingFormConstants.communityId: communityId.toString(),
        },
      );
    }

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
        widget.accountType == AppConstants.personalStr;
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
      visible: (widget.accountType == AppConstants.businessStr ||
              widget.state.formDataMap?[AddListingFormConstants.accountType] == AppConstants.businessStr) &&
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

  Widget _industryType() {
    String? industryType = widget.state.formDataMap?[AddListingFormConstants.industryType] ?? '';
    CommonDropdownModel? selectedItem;
    try {
      var list = widget.state.industryType?.result;
      list = list?.where((item) => item.industryTypeName == industryType).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.industryTypeId ?? 0, name: item?.industryTypeName ?? '');
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.industryType,
          textStyle: FontTypography.subTextStyle,
        ),
        DropDownWidget2(
          hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.industryType}',
          items: widget.state.industryType?.result
              ?.map(
                (item) => CommonDropdownModel(id: item.industryTypeId ?? 0, name: item.industryTypeName ?? ''),
              )
              .toList(),
          dropDownValue: selectedItem,
          dropDownOnChange: (CommonDropdownModel? value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              keysValuesMap: {
                AddListingFormConstants.industryType: value?.name ?? '',
                AddListingFormConstants.industryTypeId: value?.id.toString(),
              },
            );
          },
        ),
      ],
    );
  }

  void handleCommunityList() {
    widget.state.formDataMap?.remove(AddListingFormConstants.businessName);
    widget.state.formDataMap?.remove(AddListingFormConstants.businessTypeId);
  }

  void handleBusinessList() {
    widget.state.formDataMap?.remove(AddListingFormConstants.community);
    widget.state.formDataMap?.remove(AddListingFormConstants.communityId);
  }
}
