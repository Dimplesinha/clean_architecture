import 'dart:io';

import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/widgets/in_app_web_view.dart';
import 'package:workapp/src/utils/add_listing_form_utils/form_validation_utils.dart';
import 'package:workapp/src/utils/file_picker_utility.dart';
import 'package:workapp/src/utils/utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/10/24
/// @Message : [UploadResumeWidget]

class UploadResumeWidget extends StatefulWidget {
  final String label;
  final int? imageControlID;
  final String? imageControlLabel;
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const UploadResumeWidget({
    super.key,
    this.imageControlLabel,
    this.imageControlID,
    required this.label,
    required this.addListingFormCubit,
    required this.state,
  });

  @override
  State<UploadResumeWidget> createState() => _UploadResumeWidgetState();
}

class _UploadResumeWidgetState extends State<UploadResumeWidget> {
  @override
  Widget build(BuildContext context) {
    var link = widget.state.formDataMap?[widget.label] as String?;
    return Visibility(
      visible:  link?.isNotEmpty == true,
      replacement: pickResumeWidget(),
      child: Stack(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () {
                AppRouter.push(
                  AppRoutes.inAppWebView,
                  args: WorkAppWebView(url: widget.state.formDataMap?[widget.label]),
                );
              },
            ),
          ),
          Positioned(
            top: -6,
            right: 4,
            child: InkWell(
              onTap:onDeleteResume,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: AppUtils.elevatedCircleAvatar(
                  size: 26,
                  path: AssetPath.deleteIcon,
                  onPressed: onDeleteResume,
                  iconSize: 16,
                  iconColor: AppColors.blackColor,
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pickResumeWidget() {
    return InkWell(
      onTap: () async {
        (bool, String) isValid = await ListingFormValidationUtils.checkValidations(
          formData: widget.addListingFormCubit.state.formDataMap,
          category: widget.addListingFormCubit.state.category,
          currentFormIndex: widget.addListingFormCubit.state.currentSectionCount ?? 0, section: [],
        );
        if (!isValid.$1) {
          AppUtils.showFormErrorSnackBar(msg: isValid.$2);
          return;
        }
        widget.addListingFormCubit.showLoading();
        File? file = await FilePickerUtility.getFile(allowedFileTypes: ['pdf']);
        if (file != null) {
          widget.addListingFormCubit.pdfFilePath = file.path;
          widget.addListingFormCubit.pdfLabel = widget.label;

          if (widget.addListingFormCubit.state.apiResultId != null) {
            onFileSelected(filePath: file.path);
          } else {
           // await widget.addListingFormCubit.onNextButtonClick(isFromSubmitButton: false, isUpdatingFile: true);
            await widget.addListingFormCubit.onUploadResume(imageControlLabel: widget.label, imageControlID: widget.imageControlID ?? 0, key: widget.label, filePath: file.path);
          }
        } else {
          AppUtils.showErrorSnackBar(AppConstants.somethingWentWrong);
        }
      },
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGreyColor),
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        child: Center(
          child: ReusableWidgets.createSvg(path: AssetPath.uploadIcon, size: 27),
        ),
      ),
    );
  }

  void onFileSelected({required String filePath}) {
    widget.addListingFormCubit.onUploadResume(
      imageControlID: widget.imageControlID ?? 0,
      imageControlLabel: widget.imageControlLabel ?? '',
      key: widget.label,
      filePath: filePath,
    );
  }

  void onDeleteResume() {
    widget.addListingFormCubit.onResumeDeleted(
      key: widget.label,
      imagePath: widget.state.formDataMap?[widget.label],
    );
  }
}
