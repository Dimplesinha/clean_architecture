import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/utils/animated_expansion_tile.dart';


class CreateExpansionTile extends StatelessWidget {
  final List<Widget> childrenWidget;
  final AnimatedExpansionTileController controller;
  final bool isExpanded;
  final void Function() onExpansionChanged;

  const CreateExpansionTile({
    super.key,
    required this.childrenWidget,
    required this.controller,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedExpansionTile(
      controller: controller,
      initiallyExpanded: true,
      trailing: arrowIcon(),
      onExpansionChanged: (value) {
        onExpansionChanged.call();
        value ? controller.expand() : controller.collapse();
      },
      children: childrenWidget,
    );
  }

  Widget arrowIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0,bottom: 16),
      child: Icon(
        isExpanded ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_right,
        color: AppColors.primaryColor,
        size: 32,
      ),
    );
  }
}
