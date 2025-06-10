import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/app_colors.dart';


/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04/09/24
/// @Message : [SocialMediaButton]
/// A custom button widget designed for social media authentication.
///
/// The `SocialMediaButton` widget allows you to create a button with an icon and label,
/// which can be used to link or sign in with social media accounts like LinkedIn, Google, or Apple.
///
/// Responsibilities:
/// - Displays a button with customizable icon, label, background color, and border.
/// - Executes a specified function when the button is pressed.
///

class SocialMediaButton extends StatelessWidget {
  /// Function to execute when the button is pressed.
  final Function() function;

  /// Background color of the button.
  final Color backgroundColor;

  /// The label (text) to display on the button.
  final Widget label;

  /// The icon or image to display on the button.
  final Widget image;
  const SocialMediaButton({
    super.key,
    required this.function,
    required this.image,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton.icon(
          onPressed: function,  // Action to perform when button is pressed
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            backgroundColor: backgroundColor,  // Set background color
            elevation: 0,
            side: BorderSide(color: AppColors.borderColor),  // Button border color
          ),
          icon: image,  // Icon or image to display on the left side of the button
          label: label   // Text label to display on the button
      ),
    );
  }
}
