import 'package:intl/intl.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/worker_skills_model.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/widgets/category_widget.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/google_location_view.dart';
import 'package:workapp/src/presentation/modules/search/cubit/search_cubit.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/utils/add_listing_form_utils/decimal_input_formatter.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 06/09/24
/// @Message : [AdvanceSearchTab]
///
/// The `AdvanceSearchTab`  class provides a user interface for performing advanced searches in the app.
///
/// Responsibilities:
/// Responsibilities:
/// - Display a tabbed interface of one of the three sections: Advance Search
/// - Provide an advanced search form with multiple input fields for specifying search criteria.
/// - Allow users to select sorting options such as Freshest, Distance, or Price.
///
class AdvanceSearchTab extends StatefulWidget {
  final AdvanceSearchLoadedState state;
  final AdvanceSearchCubit advanceSearchCubit;
  final TextEditingController? locationController;
  final TextEditingController? keywordController;
  final Map<String, dynamic>? oldFormData;

  const AdvanceSearchTab({
    super.key,
    required this.state,
    required this.advanceSearchCubit,
    required this.locationController,
    required this.keywordController,
    required this.oldFormData,
  });

  @override
  State<AdvanceSearchTab> createState() => _AdvanceSearchTabState();
}

class _AdvanceSearchTabState extends State<AdvanceSearchTab> {
  SearchCubit searchCubit = SearchCubit();

  @override
  void initState() {
    /// If old form Data is available then updating the formData of state with old form data
    /// OldFormData is basically the form data of previous search of advance search screen
    if (widget.oldFormData != null) {
      widget.advanceSearchCubit.updateFormData(oldFormData: widget.oldFormData);
      widget.keywordController?.text = widget.oldFormData?[AppConstants.keywordHintStr] ?? '';
    }
    if (widget.state.formDataMap?[AppConstants.sortBySmallStr] == null &&
        widget.oldFormData?[AppConstants.sortBySmallStr] == null) {
      widget.advanceSearchCubit.onFieldsValueChanged(key: AppConstants.sortBySmallStr, value: 2);
    }
    if (widget.oldFormData?[AppConstants.selectCategoryIdStr] != null &&
        widget.oldFormData?[AppConstants.selectCategoryIdStr] != 0) {
      widget.advanceSearchCubit.getDynamicFormData(formId: widget.oldFormData?[AppConstants.selectCategoryIdStr]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        CategoryWidget(state: widget.state, advanceSearchCubit: widget.advanceSearchCubit),
        const SizedBox(height: 20),
        AppTextField(
          hintTxt: AppConstants.keywordHintStr,
          height: 40,
          controller: widget.keywordController,
          textCapitalization: TextCapitalization.none,
          onChanged: (value) {
            widget.advanceSearchCubit.onFieldsValueChanged(key: AppConstants.keywordHintStr, value: value);
          },
        ),
        const SizedBox(height: 20),
        GoogleLocationView(
          hintText: AppConstants.locationStr,
          locationController: widget.locationController,
          selectedLocation: widget.locationController?.text.isNotEmpty == false
              ? widget.locationController?.text??''
              : widget.state.formDataMap?[AddListingFormConstants.location],
          onLocationChanged: (Map<String, String?>? json) {
            // Extract city, state, and country based on the number of parts available
            String? city;
            String? state;
            String? country;
            String? location;
            if (json != null) {
              try {
                city = json[ModelKeys.city];
                state = json[ModelKeys.administrativeAreaLevel_1];
                country = json[ModelKeys.country];
                location = json[ModelKeys.description];
                widget.advanceSearchCubit.latitude = double.parse(json[ModelKeys.latitudeGoogleApi] ?? '0.0');
                widget.advanceSearchCubit.longitude = double.parse(json[ModelKeys.longitudeGoogleApi] ?? '0.0');
                // Update form fields with extracted values
              } catch (e) {
                if (kDebugMode) print('_ContactDetailsFormViewState.build-->${e.toString()}');
              }
            } else {
              widget.advanceSearchCubit.latitude = 0.0;
              widget.advanceSearchCubit.longitude = 0.0;
            }
            widget.advanceSearchCubit.onFieldsValueChanged(keysValuesMap: {
              AddListingFormConstants.city: city,
              AddListingFormConstants.state: state,
              AddListingFormConstants.country: country,
              AddListingFormConstants.location: location,
              AddListingFormConstants.latitude: widget.advanceSearchCubit.latitude.toString(),
              AddListingFormConstants.longitude: widget.advanceSearchCubit.longitude.toString(),
            });
          },
        ),
        _buildSection(),
        sortByRadioWidget(),
        Visibility(
          visible: widget.advanceSearchCubit.isUserLogin!,
          child: GestureDetector(
            onTap: () {
              widget.advanceSearchCubit.onFieldsValueChanged(
                key: AppConstants.saveSearchStr,
                value: !(widget.state.formDataMap?[AppConstants.saveSearchStr] ?? false),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Checkbox(
                      checkColor: AppColors.whiteColor,
                      side: BorderSide(color: AppColors.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(color: AppColors.primaryColor),
                      ),
                      activeColor: AppColors.primaryColor,
                      visualDensity: VisualDensity.standard,
                      value: widget.state.formDataMap?[AppConstants.saveSearchStr] ?? false,
                      onChanged: (value) {
                        widget.advanceSearchCubit.onFieldsValueChanged(key: AppConstants.saveSearchStr, value: value);
                      },
                    ),
                  ),
                  sizedBox5Width(),
                  Text(
                    AppConstants.saveSearchStr,
                    style: FontTypography.listingStatTxtStyle,
                  )
                ],
              ),
            ),
          ),
        ),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CancelButton(
                  bgColor: Colors.white,
                  onPressed: () {
                    widget.keywordController?.clear();
                    widget.locationController?.clear();
                    widget.advanceSearchCubit.resetFormData();
                  },
                  title: AppConstants.reset.toUpperCase(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: AppButton(
                  function: () {
                    var isPriceRange = checkPriceRange();
                    if (!isPriceRange) return;
                    widget.advanceSearchCubit.searchListingForAdvanceSearch(
                      keyword: widget.keywordController?.text,
                      location: widget.locationController?.text,
                    );
                  },
                  title: AppConstants.searchStr.toUpperCase(),
                  textStyle: FontTypography.planTxtStyle.copyWith(color: AppColors.whiteColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection() {
    final sections = widget.state.sections;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sections != null)
          for (var section in sections)
            if (section.inputFields != null) ...section.inputFields!.map((field) => _buildInputField(field)),
      ],
    );
  }

  Widget _buildInputField(InputFields field) {
    return Visibility(
      visible: field.allowSearch == true || field.allowSorting == true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelText(
            title: field.label ?? '',
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          _getFieldWidget(field),
        ],
      ),
    );
  }

  Widget _getFieldWidget(InputFields field) {
    var formFieldType = FormFieldType.values.firstWhere(
      (element) => element.value == field.type,
      orElse: () => FormFieldType.text,
    );

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
            widget.advanceSearchCubit.onFieldsValueChanged(
              key: field.controlName, // Store value uniquely
              value: value,
            );
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
            widget.advanceSearchCubit.onFieldsValueChanged(
              key: field.controlName,
              value: value,
            );
          },
        );
      case FormFieldType.location:
        return AppTextField(
          key: ValueKey(field.controlId),
          hintTxt: field.placeholder ?? '',
          initialValue: widget.state.formDataMap?[field.controlName],
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: (value) {
            widget.advanceSearchCubit.onFieldsValueChanged(
              key: field.controlName,
              value: value,
            );
          },
        );
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
                                    widget.advanceSearchCubit.onSkillRemoved(skill);
                                    final formKey = field.controlName ?? '';
                                    final skillString = widget.state.formDataMap?[formKey] ?? '';
                                    // Convert to list
                                    List<dynamic> skillIds = skillString.split(',').map((e) => e.trim()).toList();
                                    // Remove the skillId
                                    skillIds.remove(skill.skillId.toString());
                                    // Join back to string
                                    final updatedSkillString = skillIds.join(',');
                                    // Update the formDataMap
                                    widget.advanceSearchCubit.onFieldsValueChanged(
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
          List<CommonDropdownModel> dropdownList = _getDropdownList(field.bindDropdown, field);
          final List<CommonDropdownModel> modifiedDropdownList = [
            CommonDropdownModel(name: 'Select', code: '', id: null),
            ...dropdownList,
          ];

          return DropDownWidget2(
            hintText: field.placeholder,
            items: modifiedDropdownList,
            dropDownValue: _getSelectedDropdownItem(field, field.bindDropdown),
            dropDownOnChange: (CommonDropdownModel? value) {
              /// Store selected value
              widget.advanceSearchCubit.onFieldsValueChanged(
                key: field.controlName,
                value: value?.code.toString() ?? '',
              );
            },
          );
        }
      case FormFieldType.radio:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: field.options?.map((option) {
                return _buildRadioOption(
                  option.id ?? 0,
                  widget.state,
                  option.label ?? '',
                  field.controlName ?? '',
                );
              }).toList() ??
              [],
        );
      case FormFieldType.priceRange:
      case FormFieldType.price:
        final List<CommonDropdownModel> dropdownList = [
          CommonDropdownModel(name: 'Select Sort Order', code: '', id: null),
          CommonDropdownModel(name: 'High to Low', code: '1', id: 1),
          CommonDropdownModel(name: 'Low to High', code: '2', id: 2),
        ];
        final String? selectedSortCode = widget.state.formDataMap?['Sort'];
        CommonDropdownModel selectedValue = dropdownList.firstWhere(
          (item) => item.code == selectedSortCode,
          orElse: () => dropdownList[0], // Default to 'Select'
        );

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

        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AppTextField(
                    key: ValueKey('${field.controlName}_min'),
                    hintTxt: '${AddListingFormConstants.minSalary} ${field.label}',
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
                      widget.advanceSearchCubit.onFieldsValueChanged(
                        key: field.controlName,
                        value: '$rawMin,${maxValue.trim()}',
                      );
                    },
                  ),
                ),
                sizedBox10Width(),
                Flexible(
                  child: AppTextField(
                    key: ValueKey('${field.controlName}_max'),
                    hintTxt: '${AddListingFormConstants.maxSalary} ${field.label}',
                    initialValue: formattedMaxValue == 'null' ? '' : formattedMaxValue,
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

                      widget.advanceSearchCubit.onFieldsValueChanged(
                        key: field.controlName,
                        value: '${minValue.trim()},$rawMax',
                      );
                    },
                  ),
                ),
              ],
            ),
            LabelText(
              title: 'Sort',
              textStyle: FontTypography.subTextStyle,
              isRequired: false,
            ),
            DropDownWidget2(
              hintText: field.placeholder,
              items: dropdownList,
              dropDownValue: selectedValue,
              dropDownOnChange: (CommonDropdownModel? value) {
                /// Store selected value
                widget.advanceSearchCubit.onFieldsValueChanged(
                  key: 'Sort',
                  value: value?.code.toString() ?? '',
                );
                widget.advanceSearchCubit.onFieldsValueChanged(
                  key: AppConstants.sortByStr,
                  value: field.controlId,
                );
                selectedValue = value!;
              },
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  CommonDropdownModel? _getSelectedDropdownItem(InputFields field, int? bindDropdown) {
    String? selectedValue = widget.state.formDataMap?[field.controlName];

    List<CommonDropdownModel> list = [];

    switch (bindDropdown ?? 1) {
      case 1:
        list = field.options
                ?.map((option) => CommonDropdownModel(id: option.id, name: option.label, code: option.value))
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
      //   case 3:
      //     list = widget.state.i
      //         ?.map((option) => CommonDropdownModel(
      //         id: option.listingId,
      //         name: option.listingName,
      //         code: option.listingId.toString()))
      //         .toList() ??
      //         [];
      //     break;
      default:
        list = list = field.options
                ?.map((option) => CommonDropdownModel(id: option.id, name: option.label, code: option.value))
                .toList() ??
            [];
    }

    return list.firstWhere(
      (option) => option.code == selectedValue,
      orElse: () => CommonDropdownModel(id: 0, name: field.placeholder ?? ''),
    );
  }

  List<CommonDropdownModel> _getDropdownList(int? bindDropdown, InputFields field) {
    List<CommonDropdownModel> list = [];

    switch (bindDropdown ?? 0) {
      case 1:
        list = field.options
                ?.map((option) => CommonDropdownModel(id: option.id, name: option.label, code: option.value))
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
        list = field.options
                ?.map((option) => CommonDropdownModel(id: option.id, name: option.label, code: option.value))
                .toList() ??
            [];
        break;
      default:
        list = field.options
                ?.map((option) => CommonDropdownModel(id: option.id, name: option.label, code: option.value))
                .toList() ??
            [];
    }

    return list;
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

  selectSkillsBottomSheet(String keyLabel, String valueLabel, String fieldLabel) {
    return AppUtils.showBottomSheet(
      context,
      onCancel: () {
        widget.advanceSearchCubit.onFilterSkills('');
      },
      child: BlocBuilder<AdvanceSearchCubit, AdvanceSearchState>(
        bloc: widget.advanceSearchCubit,
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
                      widget.advanceSearchCubit.onAllSkillSelected(
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
                            widget.advanceSearchCubit.onSkillSelected(
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

    widget.advanceSearchCubit.onFieldsValueChanged(
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
          widget.advanceSearchCubit.onFilterSkills(value);
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

  Widget sortByRadioWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AppConstants.sortBySmallStr,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
        ),
        Visibility(
          visible: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildRadioOption(2, widget.state, AddListingFormConstants.countrywide, AppConstants.sortBySmallStr),
              // Freshest option
              _buildRadioOption(1, widget.state, AddListingFormConstants.worldwide, AppConstants.sortBySmallStr),
              // Distance option
              // _buildRadioOption(3, widget.state, AppConstants.nearMeStr, AppConstants.sortBySmallStr),
              // Price option
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(int value, AdvanceSearchLoadedState state, String label, String title) {
    int mappedValue = (label.toLowerCase() == 'yes')
        ? 1
        : (label.toLowerCase() == 'no')
            ? 0
            : value;
    return Expanded(
      child: SizedBox(
        height: 20,
        width: 100,
        child: GestureDetector(
          onTap: () {
            widget.advanceSearchCubit.onFieldsValueChanged(key: title, value: mappedValue);
          },
          child: Row(
            children: [
              Radio(
                value: mappedValue,
                groupValue: state.formDataMap?[title],
                visualDensity: VisualDensity.compact,
                onChanged: (value) {
                  widget.advanceSearchCubit.onFieldsValueChanged(key: title, value: mappedValue);
                },
                activeColor: AppColors.primaryColor,
              ),
              Text(label, style: FontTypography.defaultTextStyle),
            ],
          ),
        ),
      ),
    );
  }

  bool checkPriceRange() {
    final sections = widget.state.sections;
    final allInputFields = <InputFields>[]; // or whatever your field type is

    if (sections != null) {
      for (var section in sections) {
        if (section.inputFields != null) {
          allInputFields.addAll(section.inputFields!);
        }
      }
    }

    var priceRangeFields = allInputFields
        .where(
          (field) => field.type == FormFieldType.price.value || field.type == FormFieldType.priceRange.value,
        )
        .toList();

    if (priceRangeFields.isNotEmpty) {
      final priceRangeField = priceRangeFields.first;
      final combinedValue = widget.state.formDataMap?[priceRangeField.controlName] ?? '';
      String minValue = '';
      String maxValue = '';
      if (combinedValue.contains(',')) {
        final parts = combinedValue.split(',');
        if (parts.length == 2) {
          minValue = parts[0].trim();
          maxValue = parts[1].trim();
          if (int.parse(minValue) > int.parse(maxValue)) {
            AppUtils.showSnackBar(AppConstants.minPriceRangeValidation, SnackBarType.alert);
            return false;
          }
        }
      }
    }
    return true;
  }
}
