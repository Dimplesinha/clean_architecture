import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';

class CategoryWidget extends StatefulWidget {
  final AdvanceSearchLoadedState state;
  final AdvanceSearchCubit advanceSearchCubit;

  const CategoryWidget({super.key, required this.state, required this.advanceSearchCubit});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  CommonDropdownModel? selectedItem;
  List<CommonDropdownModel>? dropDownList;

  updateSelectedItem() {
    if (widget.advanceSearchCubit.commonDropdownModel != null) {
      selectedItem = widget.advanceSearchCubit.commonDropdownModel!;
    } else {
      selectedItem = CommonDropdownModel(id: 0, name: 'All');
      widget.advanceSearchCubit.commonDropdownModel = selectedItem;
    }
    // Generate the dropdown items list
    dropDownList = widget.advanceSearchCubit.categoriesList
            ?.map((item) => CommonDropdownModel(id: item.formId ?? 0, name: item.formName ?? ''))
            .toList() ??
        [];
    // Add the default "All" option at the first position
    dropDownList?.insert(0, CommonDropdownModel(id: 0, name: 'All'));
  }

  setSelectedItem() {
    String? categoryName = widget.state.formDataMap?[AppConstants.selectCategoryStr] ?? '';
    try {
      var list = widget.advanceSearchCubit.categoriesList;
      list = list?.where((item) => item.formName == categoryName).toList();
      if (list?.isNotEmpty ?? false) {
        var item = list?.first;
        selectedItem = CommonDropdownModel(id: item?.formId ?? 0, name: item?.formName ?? '');
        widget.advanceSearchCubit.commonDropdownModel = selectedItem;
      } else {
        selectedItem = CommonDropdownModel(id: 0, name: 'All');
        widget.advanceSearchCubit.commonDropdownModel = selectedItem;
      }
    } catch (e) {
      if (kDebugMode) print('_ClassifiedBasicDetailsState._businessName $e');
    }
  }

  @override
  void initState() {
    updateSelectedItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setSelectedItem();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: AppConstants.selectCategoryStr,
          isRequired: false,
          textStyle: FontTypography.advanceScreenSortByStyle,
        ),
        DropDownWidget2(
          hintText: AppConstants.businessStr,
          items: dropDownList,
          dropDownValue: selectedItem,
          dropDownOnChange: (CommonDropdownModel? value) {
            selectedItem = value;
            widget.advanceSearchCubit.resetFormDataOnCategoryChange( formId:value?.id,categoryName:value?.name);
            widget.advanceSearchCubit.onFieldsValueChanged(
              keysValuesMap: {
                AppConstants.selectCategoryStr: value?.name,
                AppConstants.selectCategoryIdStr: value?.id,
              },
            );
          },
        ),
      ],
    );
  }
}
