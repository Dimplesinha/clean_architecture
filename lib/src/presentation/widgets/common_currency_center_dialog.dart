import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/assets_constants.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';

/// Created by
/// @AUTHOR :  Prakash Software Solutions Pvt Ltd
/// @DATE : 27-12-2024
/// @Message : [CommonSearchCurrencyDialog]

class CommonSearchCurrencyDialog extends StatefulWidget {
  final List<Countries> items;
  final String hintText;
  final TextEditingController searchController;
  final TextEditingController selectController;
  final Widget Function(Countries item) listItemBuilder;
  final Function(Countries item) onItemSelected;
  final String Function(String item) searchCriteria;
  final Color backgroundColor;

  const CommonSearchCurrencyDialog({
    Key? key,
    required this.items,
    required this.hintText,
    required this.searchController,
    required this.selectController,
    required this.listItemBuilder,
    required this.onItemSelected,
    required this.searchCriteria,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  _CommonSearchCurrencyDialogState createState() => _CommonSearchCurrencyDialogState();
}

class _CommonSearchCurrencyDialogState extends State<CommonSearchCurrencyDialog> {
  late List<Countries> filteredItems;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filterItems(String value) {
    setState(() {
      filteredItems = widget.items.where((item) {
        return widget.searchCriteria(item.currencyName!).toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.backgroundColor,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              height: 40,
              hintTxt: AddListingFormConstants.selectCurrency,
              controller: widget.searchController,
              textInputAction: TextInputAction.search,
              suffix: ReusableWidgets.createSvg(path: AssetPath.searchIconSvg),
              onChanged: _filterItems,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = filteredItems[index];
                  return InkWell(
                    onTap: () {
                      widget.onItemSelected(item);
                      Navigator.pop(context);
                    },
                    child: widget.listItemBuilder(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
