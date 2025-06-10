import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04/09/24
/// @Message : [TabAppBarView]

class TabAppBarView extends StatelessWidget implements PreferredSizeWidget {
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;
  final ScrollPhysics? scrollPhysics;
  final TabController? tabController;
  final TextStyle? unselectedLabelStyle;
  final TextStyle? labelStyle;
  final List<Widget> tabs;
  final Decoration? indicator;

  const TabAppBarView({
    super.key,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
    this.scrollPhysics,
    this.tabController,
    this.unselectedLabelStyle,
    this.labelStyle,
    required this.tabs,
    this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      overlayColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            // Return the color you want when tab is hovered
            return Colors.transparent; // Example overlay color
          }
          return Colors.grey.withOpacity(0.5); // Default overlay color
        },
      ),
      indicatorColor: indicatorColor ?? AppColors.primaryColor,
      automaticIndicatorColorAdjustment: true,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor ?? AppColors.greyUnselectedColor,
      labelStyle: labelStyle ?? FontTypography.tabBarStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? FontTypography.tabBarStyle,
      indicator: indicator ,
      physics: scrollPhysics ?? const NeverScrollableScrollPhysics(),
      controller: tabController,
      tabs: tabs
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}