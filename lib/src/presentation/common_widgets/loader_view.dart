import 'package:flutter/material.dart';
import 'package:workapp/src/core/core_exports.dart';

class LoaderView extends StatelessWidget {
  final double? height;
  final double? width;

  const LoaderView({Key? key, this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Dialog.fullscreen(
      backgroundColor: Colors.white.withOpacity(0.5),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          height: height ?? double.maxFinite,
          width: width ?? double.maxFinite,
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        ),
      ),
    ));
  }
}
