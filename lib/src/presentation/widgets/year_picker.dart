import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/profile_personal_details_exports.dart';

class SelectYear extends StatefulWidget {
  final int startYear;
  final int endYear;
  final ValueChanged<int> onYearSelected;
  final int? selectedYear;

  const SelectYear({
    Key? key,
    required this.startYear,
    required this.endYear,
    required this.onYearSelected,
    this.selectedYear,
  }) : super(key: key);

  @override
  SelectYearState createState() => SelectYearState();
}

class SelectYearState extends State<SelectYear> {
  int? _selectedYear;
  late final ScrollController _scrollController;
  final GlobalKey _gridKey = GlobalKey();
  final GlobalKey _yearKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedYear;
    _scrollController = ScrollController();

    // Scroll to selected year after first layout build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedYear();
    });
  }

  void _scrollToSelectedYear() {
    if (_selectedYear != null) {
      final selectedYearIndex = _selectedYear! - widget.startYear;
      final rowHeight = yearHeight();
      final scrollOffset = ((selectedYearIndex / 3).floor() - getNoOfRows() / 2) * rowHeight;
      _scrollController.jumpTo(scrollOffset);
    }
  }

  double getNoOfRows() {
    final gridRenderBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    final yearRenderBox = _yearKey.currentContext?.findRenderObject() as RenderBox?;

    return (gridRenderBox?.size.height != null && yearRenderBox?.size.height != null)
        ? gridRenderBox!.size.height / yearRenderBox!.size.height
        : 5;
  }

  double yearHeight() {
    final renderBox = _yearKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.height != null ? renderBox!.size.height : 50;
  }

  @override
  Widget build(BuildContext context) {
    List<int> years = List.generate(widget.endYear - widget.startYear + 1, (index) => widget.startYear + index);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(25.0),
        ),
        height: 450,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.selectYear,
              style: FontTypography.snackBarTitleStyle,
            ),
            Expanded(
              child: GridView.builder(
                key: _gridKey,
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                ),
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedYear = year;
                      });
                    },
                    child: Container(
                      key: index == 0 ? _yearKey : null,
                      margin: const EdgeInsets.all(4.0),
                      height: 50,
                      decoration: BoxDecoration(
                        color: _selectedYear == year ? AppColors.primaryColor : AppColors.whiteColor,
                        border: Border.all(
                          color: _selectedYear == year ? AppColors.primaryColor : AppColors.whiteColor,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        year.toString(),
                        style: FontTypography.defaultTextStyle.copyWith(
                          color: _selectedYear == year ? AppColors.whiteColor : AppColors.blackColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(color: AppColors.hintStyle, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    AppRouter.pop();
                  },
                  child: Text(
                    AppConstants.cancelStr,
                    style: FontTypography.categoryTagTxtStyle,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_selectedYear != null) {
                      widget.onYearSelected(_selectedYear!);
                    }
                  },
                  child: Text(
                    AppConstants.okStr,
                    style: FontTypography.categoryTagTxtStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
