import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class AutoTypeWidget extends StatefulWidget {
  final AdvanceSearchLoadedState state;
  final AdvanceSearchCubit advanceSearchCubit;

  const AutoTypeWidget({super.key, required this.state, required this.advanceSearchCubit});

  @override
  State<AutoTypeWidget> createState() => _AutoTypeWidgetState();
}

class _AutoTypeWidgetState extends State<AutoTypeWidget> {
  CommonDropdownModel? selectedItem;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.state.formDataMap?[AddListingFormConstants.autoType] != null) {
      selectedItem = CommonDropdownModel(
        id: widget.state.formDataMap?[AddListingFormConstants.autoTypeId] ?? 0,
        name: widget.state.formDataMap?[AddListingFormConstants.autoType] ?? '',
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.autoType,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
        ),
        DropDownWidget2(
          hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.autoType}',
          items: widget.state.autoTypeList
              ?.map(
                (item) => CommonDropdownModel(id: item.autoTypeId ?? 0, name: item.autoTypeName ?? ''),
              )
              .toList(),
          dropDownValue: selectedItem,
          dropDownOnChange: (CommonDropdownModel? value) {
            selectedItem = value;
            widget.advanceSearchCubit.onFieldsValueChanged(
              keysValuesMap: {
                AddListingFormConstants.autoType: value?.name,
                AddListingFormConstants.autoTypeId: value?.id,
              },
            );
          },
        ),
      ],
    );
  }
}
