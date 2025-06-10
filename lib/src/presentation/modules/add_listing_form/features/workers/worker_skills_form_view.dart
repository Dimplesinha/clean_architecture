import 'package:workapp/src/domain/models/worker_skills_model.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/upload_resume_widget.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/add_listing_form_utils/decimal_input_formatter.dart';
import 'package:workapp/src/utils/app_utils.dart';

class WorkersSkillsFormView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const WorkersSkillsFormView({
    super.key,
    required this.addListingFormCubit,
    required this.state,
  });

  @override
  State<WorkersSkillsFormView> createState() => _WorkersSkillsFormViewState();
}

class _WorkersSkillsFormViewState extends State<WorkersSkillsFormView> {
  @override
  void initState() {
    widget.addListingFormCubit.getWorkerSkills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelText(
            title: AddListingFormConstants.selectSkills,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          InkWell(
            onTap: () {
              selectSkillsBottomSheet();
            },
            child: Visibility(
              visible: widget.state.selectedSkills?.isNotEmpty ?? false,
              replacement: Container(
                width: double.infinity,
                height: AppConstants.constTxtFieldHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  color: Colors.white, // Background color
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    AddListingFormConstants.chooseYourSkill,
                    style: FontTypography.textFieldHintStyle,
                  ),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: AppConstants.constTxtFieldHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  color: Colors.white, // Background color
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Then, show the selected categories as chips
                      if (widget.state.selectedSkills != null && widget.state.selectedSkills!.isNotEmpty)
                        ...widget.state.selectedSkills!.map((skill) {
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
                              },
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          LabelText(
            title: AddListingFormConstants.maxTravelDistanceInKms,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          AppTextField(
            hintTxt: AddListingFormConstants.maxTravelDistance,
            initialValue: widget.state.formDataMap?[AddListingFormConstants.maxTravelDistanceInKms],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              DecimalInputFormatter(
                maxDigitsBeforeDecimal: AppConstants.maxDigitsBeforeDecimalValue,
                maxDigitsAfterDecimal: AppConstants.maxDigitsAfterDecimalValue,
              ),
            ],
            onChanged: (value) {
              widget.addListingFormCubit
                  .onFieldsValueChanged(key: AddListingFormConstants.maxTravelDistanceInKms, value: value);
            },
          ),
          LabelText(
            title: AddListingFormConstants.uploadResume,
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

  selectSkillsBottomSheet() {
    return AppUtils.showBottomSheet(
      context,
      onCancel: () {
        widget.addListingFormCubit.onFilterSkills('');
      },
      child: BlocBuilder<AddListingFormCubit, AddListingFormLoadedState>(
        bloc: widget.addListingFormCubit,
        builder: (context, state) {
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
                    value: widget.state.getSkills?.length == widget.state.selectedSkills?.length,
                    onChanged: (value) {
                      widget.addListingFormCubit.onAllSkillSelected(skills: widget.state.getSkills, isSelected: value);
                    },
                  ),
                  _searchWidget(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.state.getSkills?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        WorkerSkillsResult? skill = widget.state.getSkills?[index];
                        bool isChecked = widget.state.selectedSkills
                                ?.where((item) => item.skillId == skill?.skillId)
                                .toList()
                                .isNotEmpty ??
                            false;

                        return CheckboxListTile(
                          title: Text(skill?.skillName ?? ''),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: isChecked,
                          activeColor: AppColors.primaryColor,
                          checkColor: AppColors.whiteColor,
                          onChanged: (value) {
                            widget.addListingFormCubit.onSkillSelected(
                              skill: widget.state.getSkills![index],
                              isSelected: value, fieldLabel: '',
                            );
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
}
