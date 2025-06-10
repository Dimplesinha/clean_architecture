import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class PropertyTypeWidget extends StatefulWidget {
  final AdvanceSearchLoadedState state;
  final AdvanceSearchCubit advanceSearchCubit;

  const PropertyTypeWidget({super.key, required this.state, required this.advanceSearchCubit});

  @override
  State<PropertyTypeWidget> createState() => _PropertyTypeWidgetState();
}

class _PropertyTypeWidgetState extends State<PropertyTypeWidget> {
  CommonDropdownModel? selectedItem;

  @override
  void initState() {
    if (widget.state.propertyType == null) {

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.formDataMap?[AddListingFormConstants.propertyType] != null) {
      selectedItem = CommonDropdownModel(
        id: widget.state.formDataMap?[AddListingFormConstants.propertyTypeId] ?? 0,
        name: widget.state.formDataMap?[AddListingFormConstants.propertyType] ?? '',
      );
    }
    return Visibility(
      visible: widget.state.propertyType != null,
      replacement: const SizedBox.shrink(),
      child: Column(
        children: [
          LabelText(
            title: AddListingFormConstants.propertyType,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          DropDownWidget2(
            hintText: '${AddListingFormConstants.choose} ${AddListingFormConstants.propertyType}',
            items: widget.state.propertyType?.result
                ?.map(
                  (item) => CommonDropdownModel(id: item.propertyTypeId ?? 0, name: item.propertyTypeName ?? ''),
                )
                .toList(),
            dropDownValue: selectedItem,
            dropDownOnChange: (CommonDropdownModel? value) {
              selectedItem = value;
              widget.advanceSearchCubit.onFieldsValueChanged(
                keysValuesMap: {
                  AddListingFormConstants.propertyType: value?.name,
                  AddListingFormConstants.propertyTypeId: value?.id,
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
