import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/drop_down_widget.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';



class CategoryWidget extends StatefulWidget {
  final List<CategoriesListResponse> categoriesList;
  final String hintText;
  final String label;
  final Function(CommonDropdownModel) onCategorySelected;
  final bool reset;
  final CommonDropdownModel? selectedCategory;

  const CategoryWidget({
    super.key,
    required this.categoriesList,
    required this.hintText,
    required this.label,
    required this.onCategorySelected,
    this.reset = false,
    this.selectedCategory,
  });

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  CommonDropdownModel? selectedItem;
  List<CommonDropdownModel>? dropDownList;

  @override
  void initState() {
    super.initState();
    _initializeDropdownList();
  }

  @override
  void didUpdateWidget(covariant CategoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory || widget.reset != oldWidget.reset) {
      _initializeDropdownList();
    }
  }

  void _initializeDropdownList() {
    dropDownList = widget.categoriesList
        .map((item) => CommonDropdownModel(id: item.formId, name: item.formName))
        .toList();

    dropDownList?.insert(0, CommonDropdownModel(id: 0, name: AppConstants.allStr));

    // If reset flag is true, reset the selected item to "All"
    if (widget.reset) {
      selectedItem = dropDownList?.first; // Reset to "All"
    } else {
      selectedItem = widget.selectedCategory ?? dropDownList?.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
          title: widget.label,
          isRequired: false,
          textStyle: FontTypography.textFieldBlackStyle,
        ),
        DropDownWidget2(
          hintText: widget.hintText,
          items: dropDownList,
          dropDownValue: selectedItem,
          dropDownOnChange: (CommonDropdownModel? value) {
            setState(() {
              selectedItem = value;
            });
            widget.onCategorySelected(value!);
          },
        ),
      ],
    );
  }
}

