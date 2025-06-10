import 'package:intl/intl.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/worker_skills_model.dart';
import 'package:workapp/src/presentation/common_widgets/image_preview.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/business_logo_widget.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/image_list_widget.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/listing_form_image_picker.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/radio_button_widget.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/upload_resume_widget.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/app_mobile_txt_field/view/app_mobile_txt_filed.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/widgets/common_currency_center_dialog.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/text_field_dummy.dart';
import 'package:workapp/src/utils/add_listing_form_utils/decimal_input_formatter.dart';
import 'package:collection/collection.dart';

class BasicDetailsFormView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;
  final int sectionIndex;
  final int itemId;
  final String? recordStatus;

  const BasicDetailsFormView({
    super.key,
    required this.addListingFormCubit,
    required this.state,
    required this.sectionIndex,
    required this.itemId,
    required this.recordStatus,
  });

  @override
  State<BasicDetailsFormView> createState() => _BasicDetailsFormViewState();
}

class _BasicDetailsFormViewState extends State<BasicDetailsFormView> {
  final dateController = TextEditingController();
  final mobileTxtController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final countryCodeController = TextEditingController();
  final jobRequirementBulletTxtController = TextEditingController();
  final searchController = TextEditingController();
  final selectCurrencyController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  List<Countries>? currencyList;
  Map<String, String> selectedValuesMap = {};
  CommonDropdownModel? selectedItem;
  String? accountType;

  bool show = false;

  @override
  void initState() {
    startDateController.text = '';
    endDateController.text = '';
    mobileTxtController.text = widget.state.formDataMap?[AddListingFormConstants.phoneNumber] ?? '';
    phoneCodeController.text = widget.state.formDataMap?[AddListingFormConstants.phoneDialCode] ?? '';
    countryCodeController.text =
        widget.state.formDataMap?[AddListingFormConstants.phoneCountryCode]?.toString().toUpperCase() ?? '';
    _checkAndHandleClassifiedType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final section = (widget.state.sections != null && widget.sectionIndex < widget.state.sections!.length)
        ? widget.state.sections![widget.sectionIndex]
        : null;

    if (section == null) {
      return const SizedBox.shrink();
    }
    final accountType = AppUtils.loginUserModel?.accountType?.toString();
    final allFields = section.inputFields ?? [];

    final allowedFields = allFields.where((field) {
      final allowedTypes = field.controlAccountType?.split(',').map((e) => e.trim()).toList();
      return allowedTypes?.contains(accountType) ?? true;
    }).toList();

    final allowedFieldKeys = allowedFields.map((field) => field.controlName ?? '').toSet();

    dateController.text = widget.state.selectedDate ?? '';

    var startDate = AppUtils.formatDate(widget.state.formDataMap?[AddListingFormConstants.startDate] ?? '');
    startDateController.text = startDate!;

    var endDate = AppUtils.formatDate(widget.state.formDataMap?[AddListingFormConstants.endDate] ?? '');
    endDateController.text = endDate!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: _buildSection(section, allowedFieldKeys),
    );
  }

  Widget _buildSection(Sections section, Set<String> allowedFieldKeys) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...?section.inputFields?.map((field) => _buildInputField(field, allowedFieldKeys)).toList(),
      ],
    );
  }

  Widget _buildInputField(InputFields field, Set<String> allowedFieldKeys) {
    final isVisible = shouldShowField(field, allowedFieldKeys);

    // Update validation of dependent fields
    updateDependentFieldValidation(field);

    // Update address related data
    updateAddressRelatedData(field);

    return Visibility(
      visible: isVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelText(
            title: field.label ?? '',
            textStyle: FontTypography.subTextStyle,
            isRequired: field.formValidations?.isRequired ?? false,
          ),
          _getFieldWidget(field),
        ],
      ),
    );
  }

  Widget _getFieldWidget(InputFields field) {
    var formFieldType = _getFormFieldTypeBySection(field);

    switch (formFieldType) {
      ///To give text input
      case FormFieldType.text:
      case FormFieldType.listingTitle:
      case FormFieldType.streetAddress:
      case FormFieldType.contactName:
        return AppTextField(
          key: ValueKey(field.controlId),
          hintTxt: field.placeholder ?? '',
          initialValue: widget.state.formDataMap?[field.controlName], // Use unique key
          onChanged: (value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              key: field.controlName, // Store value uniquely
              value: value,
            );
            selectedValuesMap[field.controlName ?? ''] = widget.state.formDataMap?[field.controlName];
            if (widget.state.formDataMap?[field.controlName] == '') {
              widget.state.formDataMap?.remove(field.controlName);
            }
          },
        );

      case FormFieldType.number:
        return AppTextField(
          key: ValueKey(field.controlId),
          hintTxt: field.placeholder ?? '',
          initialValue: widget.state.formDataMap?[field.controlName],
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: (value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              key: field.controlName,
              value: value,
            );
            selectedValuesMap[field.controlName ?? ''] = widget.state.formDataMap?[field.controlName];
            if (widget.state.formDataMap?[field.controlName] == '') {
              widget.state.formDataMap?.remove(field.controlName);
            }
          },
        );

      /// To show dropdown to select any option (can be multiselect in case of job skills)
      case FormFieldType.select:
      case FormFieldType.visibility:
      case FormFieldType.duration:
        if (field.isMultiSelect == true) {
          return InkWell(
            onTap: () {
              selectSkillsBottomSheet(field.keyLabel ?? '', field.valueLabel ?? '', field.controlName ?? '');
            },
            child: Visibility(
              visible: widget.state.masterData?.isNotEmpty ?? false,
              child: Container(
                width: double.infinity,
                height: AppConstants.constTxtFieldHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Builder(
                    builder: (context) {
                      final selectedSkills = widget.state.selectedSkills;
                      List<WorkerSkillsResult> formSkills = [];
                      final savedSkillString = widget.state.formDataMap?[field.controlName];
                      if ((selectedSkills == null || selectedSkills.isEmpty) && savedSkillString != null) {
                        final selectedIds = savedSkillString.split(',').map((e) => e.trim()).toList();
                        formSkills = widget.state.masterData
                                ?.map((item) {
                                  final id = item.toJson()[field.valueLabel];
                                  final name = item.toJson()[field.keyLabel]?.toString();
                                  return WorkerSkillsResult(skillId: id, skillName: name);
                                })
                                .where((skill) => selectedIds.contains(skill.skillId.toString())) // <-- FIXED
                                .toList() ??
                            [];
                      }

                      final skillsToShow = selectedSkills?.isNotEmpty == true ? selectedSkills! : formSkills;

                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          if (skillsToShow.isNotEmpty)
                            ...skillsToShow.map((skill) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(21),
                                  ),
                                  deleteIcon: ReusableWidgets.createSvg(
                                    path: AssetPath.removeSearchIcon,
                                    color: AppColors.whiteColor,
                                    size: 12,
                                  ),
                                  side: const BorderSide(color: Colors.transparent),
                                  backgroundColor: AppColors.primaryColor,
                                  label: Text(
                                    skill.skillName ?? '',
                                    style: FontTypography.listingStatTxtStyle.copyWith(color: AppColors.whiteColor),
                                  ),
                                  onDeleted: () {
                                    widget.addListingFormCubit.onSkillRemoved(skill);
                                    final formKey = field.controlName ?? '';
                                    final skillString = widget.state.formDataMap?[formKey] ?? '';
                                    // Convert to list
                                    List<dynamic> skillIds = skillString.split(',').map((e) => e.trim()).toList();
                                    // Remove the skillId
                                    skillIds.remove(skill.skillId.toString());
                                    // Join back to string
                                    final updatedSkillString = skillIds.join(',');
                                    // Update the formDataMap
                                    widget.addListingFormCubit.onFieldsValueChanged(
                                      key: formKey,
                                      value: updatedSkillString,
                                    );
                                  },
                                ),
                              );
                            }).toList()
                          else
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                AddListingFormConstants.chooseYourSkill,
                                style: FontTypography.textFieldHintStyle,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          // Create a new list with 'Select' as the first item
          List<CommonDropdownModel> dropdownList = _getDropdownList(field.bindDropdown, field);
          final bool isVisibilityField = field.controlName == FormFieldType.visibility.value;

          final List<CommonDropdownModel> modifiedDropdownList;

          if (isVisibilityField) {
            modifiedDropdownList = dropdownList;
          } else if (field.controlName == AppConstants.businessOrCommunityOrganization &&
              (field.formValidations?.isRequired == false)) {
            modifiedDropdownList = [
              CommonDropdownModel(name: AppConstants.privateListing, code: '', id: null),
              ...dropdownList,
            ];
          } else {
            modifiedDropdownList = [
              CommonDropdownModel(name: 'Select', code: '', id: null),
              ...dropdownList,
            ];
          }
          if (widget.state.formDataMap?[field.controlName] == '') {
            widget.state.formDataMap?.remove(field.controlName);
          }
          if (isVisibilityField) {
            if ((widget.state.formDataMap?[field.controlName] ?? '').toString().isEmpty) {
              final dropDownItem = dropdownList.first;
              selectedItem = dropDownItem;

              widget.addListingFormCubit.onFieldsValueChanged(
                key: field.controlName,
                value: dropDownItem.code.toString(),
              );

              field.controlValue = dropDownItem.code.toString();
            }
          }

          // Try to get any previously selected value
          final existingValue = _getSelectedDropdownItem(field, field.bindDropdown);

          // If no previous value, default to "Select"
          final initialSelectedItem = existingValue ?? modifiedDropdownList.first;

          return Column(
            children: [
              DropDownWidget2(
                bindValue: field.bindDropdown,
                uniqueKey: ValueKey(field.controlId),
                hintText: field.placeholder,
                items: modifiedDropdownList,
                dropDownValue: initialSelectedItem,
                dropDownOnChange: (CommonDropdownModel? value) {
                  final selectedCode = value?.code.toString() ?? '';
                  // Always save selected code; blank string for "Select"

                  widget.addListingFormCubit.onFieldsValueChanged(
                    key: field.controlName,
                    value: selectedCode,
                  );
                  if (value?.name == AddListingFormConstants.free) {
                    widget.addListingFormCubit.disableField(true);
                    widget.state.formDataMap?.remove(AddListingFormConstants.currency.toLowerCase());
                    widget.state.formDataMap?.remove(AddListingFormConstants.price.toLowerCase());
                    selectCurrencyController.clear();
                  } else if (field.controlName == AddListingFormConstants.classifiedTypeStr &&
                      value?.name != AddListingFormConstants.free) {
                    widget.addListingFormCubit.disableField(false);
                  }
                  selectedValuesMap[field.controlName ?? ''] = selectedCode;
                  // Handle connected fields
                  List<InputFields> connectedFields = (widget.state.listings?.sections
                              ?.expand((section) => section.inputFields ?? [])
                              .where((a) => a.connectedTo == field.controlName)
                              .toList() ??
                          [])
                      .cast<InputFields>();

                  for (var connectedField in connectedFields) {
                    field.controlValue = selectedCode;

                    List<String> comparedValues =
                        connectedField.comparedValue?.split(',').map((e) => e.trim()).toList() ?? [];

                    bool shouldShow = comparedValues.contains(selectedCode);

                    if (shouldShow && connectedField.inheritControlId != null && connectedField.inheritControlId != 0) {
                      widget.addListingFormCubit.getInheritListing(
                        comparedValue: connectedField.comparedValue ?? '',
                        controlId: connectedField.inheritControlId!,
                        types: connectedField.inheritListingType ?? '',
                        formId: connectedField.inheritListingId ?? 0,
                      );
                    }
                    if (!shouldShow) {
                      hideConnectedFieldRecursively(connectedField);
                    }

                    if (!shouldShow && connectedField.formValidations?.isRequired == true) {
                      connectedField.formValidations?.isRequired = false;
                    } else if (shouldShow && field.formValidations?.isRequired == true) {
                      connectedField.formValidations?.isRequired = true;
                    }
                  }
                },
              ),
              Visibility(
                  visible: field.controlName == AddListingFormConstants.businessTypeStr &&
                      widget.itemId != 0 &&
                      widget.recordStatus != RecordStatusString.draft.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      AppConstants.warningBeforeEdit,
                      style: FontTypography.listingFormSubTitleStyle,
                    ),
                  ))
            ],
          );
        }

      ///To show description text
      case FormFieldType.textarea:
      case FormFieldType.listingDescription:
        return AppTextField(
          key: ValueKey(field.controlId),
          hintTxt: field.placeholder ?? '',
          // initialValue: widget.state.formDataMap?[field.controlName] ?? '',
          initialValue: widget.state.formDataMap?[field.controlName],
          height: 130,
          maxLines: 6,
          topPadding: 12,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              key: field.controlName,
              value: value,
            );
            selectedValuesMap[field.controlName ?? ''] = widget.state.formDataMap?[field.controlName];
            if (widget.state.formDataMap?[field.controlName] == '') {
              widget.state.formDataMap?.remove(field.controlName);
            }
          },
        );

      ///
      case FormFieldType.radio:
        return Wrap(
          key: ValueKey(field.controlId),
          spacing: 20.0,
          runSpacing: 0.0,
          children: field.options?.map((option) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioButton(
                        state: widget.state,
                        formConstantKey: field.controlName ?? '',
                        addListingFormCubit: widget.addListingFormCubit,
                        title: option.label ?? '',
                        value: option.value ?? '',
                        onChangeAdditionalMethod: () {
                          selectedValuesMap[field.controlName ?? ''] = widget.state.formDataMap?[field.controlName];
                          List<InputFields> connectedFields = (widget.state.listings?.sections
                                      ?.expand((section) => section.inputFields ?? [])
                                      .where((a) => a.connectedTo == field.controlName)
                                      .toList() ??
                                  [])
                              .cast<InputFields>();

                          // Show or hide connected fields dynamically
                          for (var connectedField in connectedFields) {
                            field.controlValue = option.value;

                            // Handle multiple compared values
                            List<String> comparedValues =
                                connectedField.comparedValue?.split(',').map((e) => e.trim()).toList() ?? [];

                            bool shouldShow = comparedValues.contains(selectedValuesMap[field.controlName]);

                            if (shouldShow &&
                                connectedField.inheritControlId != null &&
                                connectedField.inheritControlId != 0) {
                              widget.addListingFormCubit.getInheritListing(
                                comparedValue: connectedField.comparedValue ?? '',
                                controlId: connectedField.inheritControlId!,
                                types: connectedField.inheritListingType ?? '',
                                formId: connectedField.inheritListingId ?? 0,
                              );
                            }

                            if (!shouldShow) {
                              hideConnectedFieldRecursively(connectedField);
                            }

                            // Update validation based on visibility
                            if (!shouldShow && connectedField.formValidations?.isRequired == true) {
                              connectedField.formValidations?.isRequired = false;
                            }
                          }
                        })
                  ],
                );
              }).toList() ??
              [],
        );

      case FormFieldType.date:
      case FormFieldType.listingExpiryDate:
        return InkWell(
          onTap: () async {
            widget.addListingFormCubit.openDynamicDatePicker(
              context,
              field.controlName ?? '',
            );
          },
          child: AppTextField(
            controller: dateController,
            isReadOnly: true,
            isEnable: false,
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: ReusableWidgets.createSvg(path: AssetPath.calendarIcon),
            ),
            hintTxt: AppUtils.formatDate(
              widget.state.formDataMap?[field.controlName] ?? field.placeholder,
            ),
            hintStyle: widget.state.formDataMap?[field.controlName] != null
                ? FontTypography.textFieldBlackStyle
                : FontTypography.textFieldHintStyle,
            initialValue: null,
            textInputAction: TextInputAction.next,
          ),
        );
      case FormFieldType.listingDateRange:
      case FormFieldType.dateRange:
        final savedPromoRange = widget.state.formDataMap?[field.controlName ?? ''] ?? '';
        if (savedPromoRange.isNotEmpty && startDateController.text.isEmpty && endDateController.text.isEmpty) {
          widget.addListingFormCubit.setStartAndEndDateFromString(savedPromoRange);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  await widget.addListingFormCubit.openDatePicker(
                    context,
                    isFromStartDate: true,
                    hasStartEndDate: true,
                  );

                  final startDate = widget.state.formDataMap?[AddListingFormConstants.startDate] ?? '';
                  final endDate = widget.state.formDataMap?[AddListingFormConstants.endDate] ?? '';
                  final promoDateRange = '${AppUtils.promoDateRange(startDate)},${AppUtils.promoDateRange(endDate)}';
                  widget.addListingFormCubit.onFieldsValueChanged(
                    key: field.controlName ?? '',
                    value: promoDateRange,
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
                  hintTxt: startDateController.text.isNotEmpty
                      ? startDateController.text
                      : AddListingFormConstants.startDate,
                  hintStyle: startDateController.text.isNotEmpty
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
                onTap: () {
                  widget.addListingFormCubit.openDatePicker(
                    context,
                    isFromStartDate: false,
                    hasStartEndDate: true,
                  );
                  final startDate = widget.state.formDataMap?[AddListingFormConstants.startDate] ?? '';
                  final endDate = widget.state.formDataMap?[AddListingFormConstants.endDate] ?? '';
                  final promoDateRange = '${AppUtils.promoDateRange(startDate)},${AppUtils.promoDateRange(endDate)}';
                  widget.addListingFormCubit.onFieldsValueChanged(key: field.controlName ?? '', value: promoDateRange);
                },
                child: AppTextField(
                  controller: endDateController,
                  isReadOnly: true,
                  isEnable: false,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: ReusableWidgets.createSvg(path: AssetPath.calendarIcon),
                  ),
                  hintTxt: endDateController.text.isNotEmpty ? endDateController.text : AddListingFormConstants.endDate,
                  hintStyle: endDateController.text.isNotEmpty
                      ? FontTypography.textFieldBlackStyle
                      : FontTypography.textFieldHintStyle,
                  initialValue: null,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ],
        );

      case FormFieldType.businessWebsite:
      case FormFieldType.website:
        return AppTextField(
          key: ValueKey(field.controlId),
          hintTxt: field.placeholder ?? '',
          initialValue: widget.state.formDataMap?[field.controlName],
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.url,
          textCapitalization: TextCapitalization.none,
          onChanged: (value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              key: field.controlName,
              value: value,
            );
            selectedValuesMap[field.controlName ?? ''] = widget.state.formDataMap?[field.controlName];
            if (widget.state.formDataMap?[field.controlName] == '') {
              widget.state.formDataMap?.remove(field.controlName);
            }
          },
        );
      case FormFieldType.file:
        widget.state.formDataMap?[field.controlName ?? ''] = field.controlValue;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: UploadResumeWidget(
                imageControlID: field.controlId,
                imageControlLabel: field.controlName,
                label: field.controlName ?? '',
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
        );
      case FormFieldType.location:
        return GoogleLocationView(
          hintText: field.placeholder,
          selectedLocation: widget.state.formDataMap?[field.controlName],
          onLocationChanged: (Map<String, String?>? json) {
            // Extract city, state, and country based on the number of parts available
            String? city = '';
            String? state = '';
            String? country = '';
            String? location;
            if (json != null) {
              try {
                city = json[ModelKeys.city];
                state = json[ModelKeys.administrativeAreaLevel_1];
                country = json[ModelKeys.country];
                location = json[ModelKeys.description];
                widget.addListingFormCubit.latitude = double.parse(json[ModelKeys.latitudeGoogleApi] ?? '0.0');
                widget.addListingFormCubit.longitude = double.parse(json[ModelKeys.longitudeGoogleApi] ?? '0.0');
                // Update form fields with extracted values
              } catch (e) {
                if (kDebugMode) print('_ContactDetailsFormViewState.build-->${e.toString()}');
              }
            } else {
              widget.addListingFormCubit.latitude = 0.0;
              widget.addListingFormCubit.longitude = 0.0;
            }

            widget.addListingFormCubit.onFieldsValueChanged(
              key: AddListingFormConstants.latitude.toLowerCase(),
              value: widget.addListingFormCubit.latitude.toString(),
            );

            widget.addListingFormCubit.onFieldsValueChanged(
              key: AddListingFormConstants.longitude.toLowerCase(),
              value: widget.addListingFormCubit.longitude.toString(),
            );

            widget.addListingFormCubit.onFieldsValueChanged(
              key: field.controlName,
              value: location,
            );
            widget.addListingFormCubit
                .onFieldsValueChanged(key: AddListingFormConstants.city.toLowerCase(), value: city ?? '');
            widget.addListingFormCubit
                .onFieldsValueChanged(key: AddListingFormConstants.state.toLowerCase(), value: state ?? '');
            widget.addListingFormCubit
                .onFieldsValueChanged(key: AddListingFormConstants.country.toLowerCase(), value: country ?? '');
          },
        );
      case FormFieldType.email:
      case FormFieldType.contactEmail:
        return AppTextField(
          key: ValueKey(field.controlId),
          hintTxt: field.placeholder ?? '',
          initialValue: widget.state.formDataMap?[field.controlName],
          textCapitalization: TextCapitalization.none,
          onChanged: (value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              key: field.controlName,
              value: value,
            );
          },
        );

      case FormFieldType.phoneNumber:
        /*if (field.controlValue?.isNotEmpty == true && mobileTxtController.text.isEmpty) {
          widget.state.formDataMap?[field.controlName ?? ''] = field.controlValue;
          mobileTxtController.text = field.controlValue ?? '';
        }*/
        return AppMobileTextField(
          mobileTextEditController: mobileTxtController,
          phoneCodeController: phoneCodeController,
          hintText: field.placeholder,
          onChanged: (value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              key: field.controlName ?? '',
              value: value,
            );
            // Sync form data map: clear it if the value is empty
            if (value.isEmpty) {
              widget.state.formDataMap?[field.controlName ?? ''] = '';
            } else {
              widget.state.formDataMap?[field.controlName ?? ''] = value;
            }
          },
          countryCodeController: countryCodeController,
          onPhoneCountryChanged: (String countryCode, String countryPhoneCode, bool isApply) {
            if (isApply) {
              mobileTxtController.text = ''; // Clear phone number when country changes
              widget.state.formDataMap?[field.controlName ?? ''] = '';
            }
            countryCodeController.text = countryCode;
            phoneCodeController.text = countryPhoneCode;

            widget.addListingFormCubit.onFieldsValueChanged(
              key: AddListingFormConstants.phoneDialCode,
              value: phoneCodeController.text,
            );
            widget.addListingFormCubit.onFieldsValueChanged(
              key: FormFieldType.phoneCountryCode.value,
              value: countryCode.toUpperCase(),
            );
            widget.addListingFormCubit.onFieldsValueChanged(
              key: FormFieldType.phoneDialCode.value,
              value: countryPhoneCode,
            );
          },
        );
      case FormFieldType.homePageLogo:
        if (widget.state.formDataMap?['homePageLogo'] != null &&
            widget.state.formDataMap?['homePageLogo']?.toString().isNotEmpty == true) {
          widget.state.businessLogo = widget.state.formDataMap?['homePageLogo'];
          widget.state.formDataMap?[AddListingFormConstants.uploadHomePageLogo] =
              widget.state.formDataMap?['homePageLogo'];
        } else {
          widget.state.businessLogo = '';
          widget.state.formDataMap?[AddListingFormConstants.uploadHomePageLogo] = '';
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.state.businessLogo == null
                  ? true
                  : widget.state.businessLogo?.isEmpty ?? true
                      ? true
                      : false,
              replacement: GestureDetector(
                onTap: () {
                  List<String> list = [];
                  list.add(widget.state.businessLogo!);
                  showDialog(
                    barrierDismissible: false,
                    context: navigatorKey.currentState!.context,
                    builder: (BuildContext context) {
                      return ImagePreview(
                        imageList: list,
                        selectedIndex: 0,
                      );
                    },
                  );
                },
                child: BusinessLogoWidget(
                  networkImagePath: widget.state.businessLogo,
                  onDeleteItemClick: () {
                    widget.addListingFormCubit.onFieldsImageDeleted(
                      imageControlID: field.controlId,
                      imageControlLabel: field.controlName,
                      key: AddListingFormConstants.uploadHomePageLogo,
                      imagePath: widget.state.businessLogo ?? '',
                      multiImageSupported: false,
                    );
                  },
                  isUploading: widget.state.isBusinessLogoUploading,
                ),
              ),
              child: ListingFormImagePicker(
                imageControlID: field.controlId,
                imageControlLabel: field.controlName,
                from: AppConstants.profileStr.toUpperCase(),
                selectedMediaSize: widget.state.imageModelList?.length ?? 0,
                addListingFormCubit: widget.addListingFormCubit,
                state: widget.state,
                label: field.controlName ?? '',
                multiFileSupport: false,
                maxMediaCount: 15,
              ),
            ),
            sizedBox20Width(),
            Flexible(
              child: Text(
                AddListingFormConstants.uploadImageMsg,
                style: FontTypography.listingStatTxtStyle,
              ),
            ),
          ],
        );
      case FormFieldType.multipleImageVideo:
        widget.state.imageModelList =
            widget.addListingFormCubit.state.imageModelList?.where((image) => image?.isDeleted != true).toList();

        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelText(
              title: AddListingFormConstants.uploadUpToMsg.replaceAll(
                '{maxUploadCount}',
                field.maxFileAllow.toString(),
              ),
              textStyle: FontTypography.listingStatTxtStyle,
              isRequired: false,
              maxLines: 4,
              padding: const EdgeInsets.only(bottom: 20),
            ),
            sizedBox10Height(),
            CreateGalleryWidget(
              imageControlID: field.controlId,
              imageControlLabel: field.controlName,
              filesMap: widget.state.formDataMap?[AddListingFormConstants.uploadPhotosAndVideos],
              addListingFormCubit: widget.addListingFormCubit,
              state: widget.state,
              mediaListModel: widget.state.imageModelList,
              maxSelectionLimit: field.maxFileAllow ?? 0,
            ),
          ],
        );
      case FormFieldType.tagInput:
        if (widget.state.formDataMap?[AddListingFormConstants.jobRequirementsBulletPoint] == null ||
            (widget.state.formDataMap?[AddListingFormConstants.jobRequirementsBulletPoint].toString().isEmpty ??
                true)) {
          if (field.controlValue?.isNotEmpty ?? false) {
            widget.addListingFormCubit.onFieldsValueChanged(
              key: AddListingFormConstants.jobRequirementsBulletPoint,
              value: field.controlValue ?? '',
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: jobRequirementBulletTxtController,
              suffixIcon: InkWell(
                onTap: () {
                  widget.addListingFormCubit.addJobRequirement(
                      jobRequirementBulletPoint: jobRequirementBulletTxtController.text, jobRequirementId: 0);
                  jobRequirementBulletTxtController.clear();
                  widget.addListingFormCubit.onFieldsValueChanged(
                    key: field.controlName,
                    value: widget.state.formDataMap?[AddListingFormConstants.jobRequirementsBulletPoint] ?? '',
                  );
                },
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: AppColors.jetBlackColor,
                  ),
                ),
              ),
              hintTxt: field.placeholder,
            ),
            Visibility(
              visible:
                  (widget.state.formDataMap?[AddListingFormConstants.jobRequirementsBulletPoint]?.isNotEmpty ?? false),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                children: (widget.state.formDataMap?[AddListingFormConstants.jobRequirementsBulletPoint] ?? '')
                    .toString()
                    .split(',')
                    .cast<String>()
                    .map((item) => item.trim())
                    .where((item) => item.isNotEmpty)
                    .map<Widget>((item) => buildChip(item, field.controlName!))
                    .toList(),
              ),
            ),
          ],
        );
      case FormFieldType.currency:
        return _currencyDropdown(field.controlName);
      case FormFieldType.time:
        return TextFieldDummy(
          value: widget.state.formDataMap?[field.controlName ?? ''] ?? AddListingFormConstants.hhMM,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: SizedBox(
              child: ReusableWidgets.createSvg(path: AssetPath.timerIcon),
            ),
          ),
          onTap: () {
            widget.addListingFormCubit.selectTimeFromPicker(
              context: context,
              formKey: field.controlName,
              timeOfDay: TimeOfDay(
                hour: widget.state.getTimeInHH(widget.state.formDataMap?[field.controlName ?? '']),
                minute: widget.state.getTimeInMM(widget.state.formDataMap?[field.controlName ?? '']),
              ),
            );
          },
        );
      case FormFieldType.timeRange:
        final combinedValue = widget.state.formDataMap?[field.controlName] ?? '';
        String fromTime = '';
        String toTime = '';

        if (combinedValue.contains(',')) {
          final parts = combinedValue.split(',');
          if (parts.length == 2) {
            fromTime = parts[0].trim();
            toTime = parts[1].trim();
          }
        }

        return Row(
          children: [
            Expanded(
              child: TextFieldDummy(
                value: fromTime.isNotEmpty ? fromTime : AddListingFormConstants.hhMM,
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: ReusableWidgets.createSvg(path: AssetPath.timerIcon),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (picked != null) {
                    final formatted = AppUtils.formatTime24Hr(picked);
                    fromTime = formatted;

                    widget.addListingFormCubit.onFieldsValueChanged(
                      key: field.controlName,
                      value: '$fromTime,${toTime.trim()}',
                    );

                    field.formValidations?.minimum = fromTime;
                  }
                },
              ),
            ),
            sizedBox10Width(),
            Expanded(
              child: TextFieldDummy(
                value: toTime.isNotEmpty ? toTime : AddListingFormConstants.hhMM,
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: ReusableWidgets.createSvg(path: AssetPath.timerIcon),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (picked != null) {
                    final formatted = AppUtils.formatTime24Hr(picked);
                    toTime = formatted;

                    widget.addListingFormCubit.onFieldsValueChanged(
                      key: field.controlName,
                      value: '${fromTime.trim()},$toTime',
                    );

                    field.formValidations?.maximum = toTime;
                  }
                },
              ),
            ),
          ],
        );

      case FormFieldType.priceRange:
        final combinedValue = widget.state.formDataMap?[field.controlName] ?? '';
        String minValue = '';
        String maxValue = '';

        if (combinedValue.contains(',')) {
          final parts = combinedValue.split(',');
          if (parts.length == 2) {
            minValue = parts[0].trim();
            maxValue = parts[1].trim();
          }
        }

        final formattedMinValue = minValue.isNotEmpty && double.tryParse(minValue) != null
            ? NumberFormat('#,###.##').format(double.parse(minValue))
            : null;

        final formattedMaxValue = maxValue.isNotEmpty && double.tryParse(maxValue) != null
            ? NumberFormat('#,###.##').format(double.parse(maxValue))
            : null;

        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: AppTextField(
                isEnable: !(widget.state.isDisable ?? false),
                key: ValueKey('${field.controlId}_min'),
                hintTxt: field.placeholder ?? AddListingFormConstants.minSalary,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  DecimalInputFormatter(
                    maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                    maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                  ),
                ],
                initialValue: formattedMinValue,
                onChanged: (value) {
                  final rawMin = value.replaceAll(',', '');
                  minValue = rawMin;

                  if (minValue.isEmpty && maxValue.isEmpty) {
                    widget.state.formDataMap?.remove(field.controlName);
                  } else {
                    final updatedValue =
                        '${minValue.isEmpty ? 'null' : minValue},${maxValue.isEmpty ? 'null' : maxValue}';
                    widget.addListingFormCubit.onFieldsValueChanged(
                      key: field.controlName,
                      value: updatedValue,
                    );
                  }
                },
              ),
            ),
            sizedBox10Width(),
            Flexible(
              child: AppTextField(
                isEnable: !(widget.state.isDisable ?? false),
                key: ValueKey('${field.controlId}_max'),
                hintTxt: field.placeholder ?? AddListingFormConstants.maxSalary,
                initialValue: formattedMaxValue,
                textInputAction: TextInputAction.done,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  DecimalInputFormatter(
                    maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                    maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
                  ),
                ],
                onChanged: (value) {
                  final rawMax = value.replaceAll(',', '');
                  maxValue = rawMax;

                  if (minValue.isEmpty && maxValue.isEmpty) {
                    widget.state.formDataMap?.remove(field.controlName);
                  } else {
                    final updatedValue =
                        '${minValue.isEmpty ? 'null' : minValue},${maxValue.isEmpty ? 'null' : maxValue}';
                    widget.addListingFormCubit.onFieldsValueChanged(
                      key: field.controlName,
                      value: updatedValue,
                    );
                  }
                },
              ),
            ),
          ],
        );

      case FormFieldType.price:
        final rawValue = widget.state.formDataMap?[field.controlName];
        final formattedInitialValue = (rawValue != null && rawValue.toString().isNotEmpty)
            ? NumberFormat('#,###.##').format(double.tryParse(rawValue.toString()) ?? 0)
            : null;

        return AppTextField(
          fillColor: (widget.state.isDisable ?? false) ? Colors.grey[200] : null,
          isEnable: !(widget.state.isDisable ?? false),
          key: ValueKey(field.controlId),
          hintTxt: field.placeholder ?? '',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          inputFormatters: [
            DecimalInputFormatter(
              maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
              maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
            ),
          ],
          initialValue: formattedInitialValue,
          onChanged: (value) {
            final rawValue = value.replaceAll(',', '');
            widget.addListingFormCubit.onFieldsValueChanged(
              key: field.controlName,
              value: rawValue,
            );
          },
        );

      case FormFieldType.checkbox:
        return Checkbox(
          checkColor: AppColors.whiteColor,
          side: BorderSide(color: AppColors.primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: BorderSide(color: AppColors.primaryColor),
          ),
          activeColor: AppColors.primaryColor,
          visualDensity: VisualDensity.standard,
          value: widget.state.formDataMap?[field.controlName] ?? false,
          onChanged: (value) {
            widget.addListingFormCubit.onFieldsValueChanged(
              key: field.controlName,
              value: value,
            );
            selectedValuesMap[field.controlName ?? ''] = widget.state.formDataMap?[field.controlName];
            if (widget.state.formDataMap?[field.controlName] == '') {
              widget.state.formDataMap?.remove(field.controlName);
            }
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildChip(String jobRequirement, String controlName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Chip(
        side: const BorderSide(color: Colors.transparent),
        label: Text(
          jobRequirement,
          style: FontTypography.snackBarButtonStyle,
        ),
        backgroundColor: AppColors.primaryColor,
        deleteIconColor: AppColors.whiteColor,
        deleteIcon: const Icon(Icons.close, size: 15.0),
        onDeleted: () {
          widget.addListingFormCubit
              .removeJobRequirement(jobRequirementBulletPoint: jobRequirement, controlName: controlName);
        },
      ),
    );
  }

  CommonDropdownModel? _getSelectedDropdownItem(InputFields field, int? bindDropdown) {
    String? selectedValue = widget.state.formDataMap?[field.controlName] ?? selectedValuesMap[field.controlName];
    List<CommonDropdownModel> list = [];

    switch (bindDropdown ?? 1) {
      case 1:
        list = field.options
                ?.map((option) => CommonDropdownModel(id: option.id, name: option.label?.trim(), code: option.value))
                .toList() ??
            [];
        break;

      ///call master api and match id with value label and name with key label
      case 2:
        list = widget.state.masterData
                ?.map((option) => CommonDropdownModel(
                    id: option.toJson()[field.valueLabel],
                    name: option.toJson()[field.keyLabel],
                    code: option.toJson()[field.valueLabel].toString()))
                .toList() ??
            [];
        break;
      case 3:
        list = widget.state.inheritList
                ?.where((option) => option.comparedValue == field.comparedValue)
                .map((option) => CommonDropdownModel(
                    id: option.listingId, name: option.listingName?.trim(), code: option.listingId.toString()))
                .toList() ??
            [];
        break;

      default:
        list = list = field.options
                ?.map((option) => CommonDropdownModel(id: option.id, name: option.label?.trim(), code: option.value))
                .toList() ??
            [];
    }

    return list.firstWhereOrNull((option) => option.code == selectedValue);
  }

  List<CommonDropdownModel> _getDropdownList(int? bindDropdown, InputFields field) {
    List<CommonDropdownModel> list = [];
    selectedValuesMap[field.controlName ?? ''] = widget.state.formDataMap?[field.controlName] ?? '';
    switch (bindDropdown ?? 0) {
      case 1:
        list = field.options
                ?.map((option) => CommonDropdownModel(id: option.id, name: option.label?.trim(), code: option.value))
                .toList() ??
            [];
        break;
      case 2:
        list = widget.state.masterData
                ?.map((option) => CommonDropdownModel(
                    id: option.toJson()[field.valueLabel],
                    name: option.toJson()[field.keyLabel],
                    code: option.toJson()[field.valueLabel].toString()))
                .toList() ??
            [];
        break;
      case 3:
        list = widget.state.inheritList
                ?.where((option) => option.comparedValue == field.comparedValue)
                .map((option) => CommonDropdownModel(
                    id: option.listingId, name: option.listingName?.trim(), code: option.listingId.toString()))
                .toList() ??
            [];
        break;

      default:
        list = list = field.options
                ?.map((option) => CommonDropdownModel(id: option.id, name: option.label?.trim(), code: option.value))
                .toList() ??
            [];
    }
    return list;
  }

  Widget _currencyDropdown(String? label) {
    /// getting selected  value
    String? currencyCode = widget.state.formDataMap?[label] ?? '';

    /// getting currencyList
    var list = widget.state.currencyList;

    /// preparing selected item model from selected currencyCode
    var currencyList = list?.where((item) {
      if (currencyCode.isNullOrEmpty()) {
        return false;
      }
      return item.currencyCode?.toLowerCase() == currencyCode?.toLowerCase();
    });

    CommonDropdownModel? selectedItem;
    if (currencyList?.isNotEmpty ?? false) {
      var item = currencyList?.first;
      selectedItem = CommonDropdownModel(
        id: int.tryParse(item?.uuid ?? ''),
        name: '${item?.currencyName} (${item?.currencySymbol})',
        code: item?.currencyCode,
      );
    }

    selectCurrencyController.text = (selectedItem?.name ?? '');

    if (selectCurrencyController.text.isEmpty && widget.state.isDisable == false) {
      checkCurrencyWithLoginUserLocation(label);
    } else if (widget.state.isDisable == true) {
      selectCurrencyController.clear();
    }

    /*return AppTextField(
      initialValue: null,
      focusNode: FocusNode()..canRequestFocus = false,
      controller: selectCurrencyController,
      hintTxt: AddListingFormConstants.selectCurrency,
      keyboardType: TextInputType.none,
      suffixIcon: SvgPicture.asset(
        AssetPath.iconDropDown,
        fit: BoxFit.none,
      ),
      onTap: () {
        //FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
        searchController.clear();
        this.currencyList = widget.state.currencyList ?? [];
        if (this.currencyList?.isNotEmpty == true) {
          buildCurrencySearchDialog(label);
        }
      },
  );*/

    return AppTextField(
      fillColor: (widget.state.isDisable ?? false) ? Colors.grey[200] : null,
      isEnable: !(widget.state.isDisable ?? false),
      controller: selectCurrencyController,
      isReadOnly: true,
      focusNode: FocusNode(),
      hintTxt: AddListingFormConstants.selectCurrency,
      keyboardType: TextInputType.none,
      suffixIcon: SvgPicture.asset(
        AssetPath.iconDropDown,
        fit: BoxFit.none,
      ),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        searchController.clear();
        currencyList = widget.state.currencyList ?? [];
        if (currencyList?.isNotEmpty == true) {
          buildCurrencySearchDialog(label);
        }
      },
    );
  }

  buildCurrencySearchDialog(String? label) {
    showDialog(
      context: context,
      builder: (context) {
        return CommonSearchCurrencyDialog(
          items: widget.state.currencyList ?? [],
          hintText: AddListingFormConstants.selectCurrency,
          searchController: searchController,
          selectController: selectCurrencyController,
          listItemBuilder: (item) {
            return ListTile(
              title: Text('${item.currencyName} (${item.currencySymbol})'),
            );
          },
          onItemSelected: (item) {
            selectCurrencyController.text = '${item.currencyName} ${item.currencyName}';
            widget.addListingFormCubit.onFieldsValueChanged(
              key: label,
              value: item.currencyCode,
            );
          },
          searchCriteria: (item) => item,
        );
      },
    );
  }

  selectSkillsBottomSheet(String keyLabel, String valueLabel, String fieldLabel) {
    return AppUtils.showBottomSheet(
      context,
      onCancel: () {
        widget.addListingFormCubit.onFilterSkills('');
      },
      child: BlocBuilder<AddListingFormCubit, AddListingFormLoadedState>(
        bloc: widget.addListingFormCubit,
        builder: (context, state) {
          // Extract skills from masterData
          List<WorkerSkillsResult>? skillList = widget.state.masterData
              ?.map((item) => WorkerSkillsResult(
                    skillId: item.toJson()[valueLabel], // Extracting id
                    skillName: item.toJson()[keyLabel], // Extracting name
                  ))
              .toList();
          _updateSelectedSkillsString(fieldLabel, skillList);

          return Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 7,
                    width: 59,
                    decoration: BoxDecoration(
                      color: AppColors.bottomSheetBarColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppConstants.selectSkillsStr,
                    style: FontTypography.bottomSheetHeading,
                  ),
                  const SizedBox(height: 20),
                  CheckboxListTile(
                    title: const Text(AppConstants.allStr),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primaryColor,
                    checkColor: AppColors.whiteColor,
                    value: skillList?.length == widget.state.selectedSkills?.length,
                    onChanged: (value) {
                      widget.addListingFormCubit.onAllSkillSelected(
                        skills: skillList,
                        isSelected: value,
                      );
                      _updateSelectedSkillsString(fieldLabel, skillList);
                    },
                  ),
                  _searchWidget(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: skillList?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        WorkerSkillsResult? skill = skillList?[index];
                        bool isChecked = false;

                        if ((widget.state.selectedSkills?.isNotEmpty ?? false)) {
                          isChecked = widget.state.selectedSkills!.any((item) => item.skillId == skill?.skillId);
                        } else {
                          // Fallback to checking saved IDs in formDataMap
                          final savedSkillIds = (widget.state.formDataMap?[fieldLabel] as String?)?.split(',') ?? [];
                          isChecked = savedSkillIds.contains(skill?.skillId.toString());
                        }

                        return CheckboxListTile(
                          title: Text(skill?.skillName ?? ''),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: isChecked,
                          activeColor: AppColors.primaryColor,
                          checkColor: AppColors.whiteColor,
                          onChanged: (value) {
                            widget.addListingFormCubit.onSkillSelected(
                              skill: skillList![index],
                              isSelected: value,
                              fieldLabel: fieldLabel,
                            );
                            _updateSelectedSkillsString(fieldLabel, skillList);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Function to Convert Selected Skills to a Comma-Separated String
  void _updateSelectedSkillsString(String fieldLabel, List<WorkerSkillsResult>? skillList) {
    List<WorkerSkillsResult>? selectedSkills = widget.state.selectedSkills;

    if (selectedSkills == null || selectedSkills.isEmpty) {
      final savedSkillIds = (widget.state.formDataMap?[fieldLabel] as String?)?.split(',') ?? [];

      selectedSkills = skillList?.where((skill) => savedSkillIds.contains(skill.skillId.toString())).toList();
    }

    String selectedSkillsString =
        selectedSkills?.map((skill) => skill.skillId).join(',') ?? widget.state.formDataMap?[fieldLabel] ?? '';

    widget.addListingFormCubit.onFieldsValueChanged(
      key: fieldLabel,
      value: selectedSkillsString,
    );
  }

  Widget _searchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppTextField(
        height: 39,
        hintTxt: AppConstants.searchStr,
        hintStyle: FontTypography.textFieldBlackStyle.copyWith(fontSize: 14.0),
        onChanged: (value) {
          widget.addListingFormCubit.onFilterSkills(value);
        },
        suffixIconConstraints: const BoxConstraints(
          minHeight: 25,
          maxHeight: 39,
          minWidth: 100,
          maxWidth: 100,
        ),
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        fillColor: AppColors.locationButtonBackgroundColor,
      ),
    );
  }


  FormFieldType _getFormFieldTypeBySection(InputFields field) {
    // Get the current section count
    int currentSectionCount = widget.state.currentSectionCount ?? 0;

    // Find the section based on currentSectionCount
    var section = widget.state.listings?.sections?.elementAt(currentSectionCount - 1);

    // Find the field in the current section
    var sectionField = section?.inputFields?.firstWhere(
      (inputField) => inputField.controlName == field.controlName,
      orElse: () => field, // Default to provided field if not found
    );

    // Return the matched FormFieldType
    return FormFieldType.values.firstWhere(
      (element) => element.value == sectionField?.type,
      orElse: () => FormFieldType.textarea,
    );
  }

  List<WorkerSkillsResult>? getSelectedSkills(InputFields field, List<String> selectedIds) {
    // Map the master data to WorkerSkillsResult and filter based on selected IDs
    var list = widget.state.masterData
        ?.map((item) => WorkerSkillsResult(
              skillId: item.toJson()[field.valueLabel], // Extracting id
              skillName: item.toJson()[field.keyLabel], // Extracting name
            ))
        // .where((skill) => selectedIds.contains(skill.skillId)) // Filter by selected skill IDs
        .toList();
    return list?.where((item) => selectedIds.contains(item.skillId.toString())).toList();
  }

  void updateAddressRelatedData(InputFields field) {
    if (field.controlName != null && field.controlName == FormFieldType.phoneCountryCode.value) {
      if ((field.controlValue?.isNotEmpty ?? false) && phoneCodeController.text.isEmpty) {
        widget.state.formDataMap?[field.controlName ?? ''] = field.controlValue?.toUpperCase();
        phoneCodeController.text = field.controlValue?.toUpperCase() ?? '';
      }
    }
    if (field.controlName != null && field.controlName == FormFieldType.phoneDialCode.value) {
      if ((field.controlValue?.isNotEmpty ?? false) && countryCodeController.text.isEmpty) {
        countryCodeController.text = field.controlValue ?? '';
      }
    }
    /*if (field.controlName != null && field.controlName == AddListingFormConstants.state.toLowerCase()) {
      if (widget.state.formDataMap?[field.controlName ?? '']?.isNotEmpty ?? false) {
        widget.state.formDataMap?[field.controlName ?? ''] = field.controlValue;
      }
    }
    if (field.controlName != null && field.controlName == AddListingFormConstants.city.toLowerCase()) {
      if (widget.state.formDataMap?[field.controlName ?? '']?.isNotEmpty ?? false) {
        widget.state.formDataMap?[field.controlName ?? ''] = field.controlValue;
      }
    }*/
  }

  void updateDependentFieldValidation(InputFields parentField) {
    final connectedFields = (widget.state.listings?.sections
                ?.expand((section) => section.inputFields ?? [])
                .where((field) => field.connectedTo == parentField.controlName)
                .toList() ??
            [])
        .cast<InputFields>();

    for (var connectedField in connectedFields) {
      final connectedKey = connectedField.connectedTo ?? '';
      final selectedValue = selectedValuesMap[connectedKey] ?? widget.state.formDataMap?[connectedKey];

      final comparedValues = connectedField.comparedValue?.split(',').map((e) => e.trim()).toList() ?? [];

      final originallyRequired = connectedField.formValidations?.isRequired ?? false;

      final shouldBeRequired = comparedValues.contains(selectedValue);

      connectedField.formValidations?.isRequired = shouldBeRequired && originallyRequired;
    }
  }

  bool shouldShowField(InputFields field, Set<String> allowedFieldKeys) {
    final accountType = AppUtils.loginUserModel?.accountType?.toString();
    final fieldKey = field.controlName ?? '';

    // STEP 1: Account type check
    final allowedAccountTypes = field.controlAccountType?.split(',').map((e) => e.trim()).toList();
    final isAccountTypeAllowed = allowedAccountTypes?.contains(accountType) ?? true;

    if (!isAccountTypeAllowed) {
      field.formValidations?.isRequired = false;
      widget.state.formDataMap?.remove(field.controlName);
      return false;
    }

    // STEP 2: Special case: showStreetAddress
    if (fieldKey == AddListingFormConstants.showStreetAddress) {
      final streetAddress = widget.state.formDataMap?[AddListingFormConstants.streetAddress];
      if (streetAddress != null) {
        return true;
      } else {
        widget.state.formDataMap?.remove(AddListingFormConstants.showStreetAddress);
        return false;
      }
    }

    // STEP 3: Connected field logic
    if ((field.connectedTo?.isNotEmpty ?? false) && (field.comparedValue?.isNotEmpty ?? false)) {
      final connectedField = field.connectedTo!;

      //  Skip comparison if connected field is NOT visible (i.e., was filtered)
      if (!allowedFieldKeys.contains(connectedField)) {
        return true;
      }

      final comparedValues = field.comparedValue!.split(',').map((e) => e.trim().toLowerCase()).toList();

      final connectedValue = selectedValuesMap[connectedField]?.toString().trim().toLowerCase() ??
          widget.state.formDataMap?[connectedField]?.toString().trim().toLowerCase() ??
          '';

      if (!comparedValues.contains(connectedValue)) {
        return false;
      }
    }

    // STEP 4: Check for hidden field type
    return field.type != FormFieldType.hidden.value;
  }

  checkCurrencyWithLoginUserLocation(String? label) {
    var countryName = AppUtils.loginUserModel?.countryName ?? '';
    for (var item in widget.state.currencyList ?? []) {
      bool? isMatched = item.countryName.toString().toLowerCase() == countryName.toLowerCase();
      if (isMatched) {
        selectCurrencyController.text = '${item.currencyName} (${item.currencySymbol})';
        widget.addListingFormCubit.onFieldsValueChanged(
          key: label,
          value: item.currencyCode,
        );
      }
    }
  }
  void _checkAndHandleClassifiedType() {
    if (widget.state.formDataMap?[AddListingFormConstants.classifiedTypeStr] == '3') {
      widget.addListingFormCubit.disableField(true);
      widget.state.formDataMap?.remove(AddListingFormConstants.currency.toLowerCase());
      widget.state.formDataMap?.remove('price');
      selectCurrencyController.clear();
    }
  }

  void hideConnectedFieldRecursively(InputFields parentField) {
    widget.addListingFormCubit.onFieldsValueChanged(
      key: parentField.controlName ?? '',
      value: '',
    );
    selectedValuesMap[parentField.controlName ?? ''] = '';

    List<InputFields> childFields = (widget.state.listings?.sections
                ?.expand((section) => section.inputFields ?? [])
                .where((a) => a.connectedTo == parentField.controlName)
                .toList() ??
            [])
        .cast<InputFields>();

    for (var child in childFields) {
      hideConnectedFieldRecursively(child);
    }
  }
}
