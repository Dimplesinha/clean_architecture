import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class WorkerSkillsWidget extends StatefulWidget {
  final AdvanceSearchLoadedState state;
  final AdvanceSearchCubit advanceSearchCubit;

  const WorkerSkillsWidget({super.key, required this.state, required this.advanceSearchCubit});

  @override
  State<WorkerSkillsWidget> createState() => _WorkerSkillsWidgetState();
}

class _WorkerSkillsWidgetState extends State<WorkerSkillsWidget> {
  CommonDropdownModel? selectedItem;

  @override
  void initState() {
    if (widget.state.skills == null) {
      widget.advanceSearchCubit.getWorkerSkills();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.formDataMap?[AddListingFormConstants.skillName] != null) {
      selectedItem = CommonDropdownModel(
        id: widget.state.formDataMap?[AddListingFormConstants.skillId] ?? 0,
        name: widget.state.formDataMap?[AddListingFormConstants.skillName] ?? '',
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.skill,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
        ),
        DropDownWidget2(
          hintText: AddListingFormConstants.chooseYourSkill,
          items: widget.state.skills?.result
              ?.map(
                (item) => CommonDropdownModel(id: item.skillId ?? 0, name: item.skillName ?? ''),
              )
              .toList(),
          dropDownValue: selectedItem,
          dropDownOnChange: (CommonDropdownModel? value) {
            selectedItem = value;
            widget.advanceSearchCubit.onFieldsValueChanged(
              keysValuesMap: {
                AddListingFormConstants.skillId: value?.id,
                AddListingFormConstants.skillName: value?.name,
              },
            );
          },
        ),
      ],
    );
  }
}
