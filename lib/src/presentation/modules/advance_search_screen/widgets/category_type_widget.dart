import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class CategoryTypeWidget extends StatefulWidget {
  final AdvanceSearchLoadedState state;
  final AdvanceSearchCubit advanceSearchCubit;

  const CategoryTypeWidget({super.key, required this.state, required this.advanceSearchCubit});

  @override
  State<CategoryTypeWidget> createState() => _CategoryTypeWidgetState();
}

class _CategoryTypeWidgetState extends State<CategoryTypeWidget> {
  CommonDropdownModel? selectedItem;

  @override
  void initState() {
    if (widget.state.categoryType == null) {
      widget.advanceSearchCubit.getCategoryType();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.state.formDataMap?[AddListingFormConstants.promoCategory] != null) {
      selectedItem = CommonDropdownModel(
        id: widget.state.formDataMap?[AddListingFormConstants.promoCategoryId] ?? 0,
        name: widget.state.formDataMap?[AddListingFormConstants.promoCategory] ?? '',
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AddListingFormConstants.categoryType,
          textStyle: FontTypography.subTextStyle,
          isRequired: false,
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
            selectedItem = value;
            widget.advanceSearchCubit.onFieldsValueChanged(
              keysValuesMap: {
                AddListingFormConstants.promoCategory: value?.name,
                AddListingFormConstants.promoCategoryId: value?.id,
              },
            );
          },
        ),
      ],
    );
  }
}
