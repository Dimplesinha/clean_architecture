import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class IndustryTypeWidget extends StatefulWidget {
  final AdvanceSearchLoadedState state;
  final AdvanceSearchCubit advanceSearchCubit;

  const IndustryTypeWidget({super.key, required this.state, required this.advanceSearchCubit});

  @override
  State<IndustryTypeWidget> createState() => _IndustryTypeWidgetState();
}

class _IndustryTypeWidgetState extends State<IndustryTypeWidget> {
  CommonDropdownModel? selectedItem;

  @override
  void initState() {
    if (widget.state.industryType == null) {
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.state.formDataMap?[AddListingFormConstants.industryType] != null){
      selectedItem = CommonDropdownModel(
        id: widget.state.formDataMap?[AddListingFormConstants.industryTypeId] ?? 0,
        name: widget.state.formDataMap?[AddListingFormConstants.industryType] ?? '',
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.industryType,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
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
            selectedItem = value;
            widget.advanceSearchCubit.onFieldsValueChanged(
              keysValuesMap: {
                AddListingFormConstants.industryType: value?.name,
                AddListingFormConstants.industryTypeId: value?.id,
              },
            );
          },
        ),
      ],
    );
  }
}
