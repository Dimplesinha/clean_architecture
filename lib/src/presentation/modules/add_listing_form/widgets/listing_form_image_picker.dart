import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/reusable_widgets.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/widgets/image_picker_selection.dart';
import 'package:workapp/src/utils/utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 09/10/24
/// @Message : [ListingFormImagePicker]

class ListingFormImagePicker extends StatefulWidget {
  final String label;
  final bool multiFileSupport;
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;
  final int selectedMediaSize;
  final int maxMediaCount;
  final int? imageControlID;
  final String? imageControlLabel;
  final String from;

  const ListingFormImagePicker({
    super.key,
    this.imageControlID,
    this.imageControlLabel,
    this.multiFileSupport = false,
    this.selectedMediaSize = 0,
    this.maxMediaCount = 15,
    this.from = '',
    required this.label,
    required this.addListingFormCubit,
    required this.state,
  });

  @override
  State<ListingFormImagePicker> createState() => _ListingFormImagePickerState();
}

class _ListingFormImagePickerState extends State<ListingFormImagePicker> {
  String filePath = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (kIsWeb) {
          final ImagePicker picker = ImagePicker();
          final image = await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            onImageSelected(filePath: image.path);
          } else {
            AppUtils.showErrorSnackBar(AppConstants.somethingWentWrong);
          }
        } else {
          ImagePickerSelection.instance.showActionSheet(
            cameraFun: () => pickImageFromSource(imageSource: ImageSource.camera),
            galleryFun: () => pickImageFromSource(imageSource: ImageSource.gallery),
          );
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
          child: ReusableWidgets.createSvg(path: AssetPath.cameraIcon, size: 27),
        ),
      ),
    );
  }

  void pickImageFromSource({required ImageSource imageSource}) async {
    await ImagePickerSelection.instance.onImageButtonPressed(
      from: widget.from,
      selectedMediaSize: widget.selectedMediaSize,
      maxSelectionLimit: widget.maxMediaCount,
      mediaSource: imageSource,
      // Correct parameter name
      resultCallback: (List<XFile?>? images) async {
        if (widget.state.apiResultId == null) {
          var response =
          await widget.addListingFormCubit.onNextButtonClick(isFromSubmitButton: false, isUpdatingFile: true, isFromResumeUpload: true);
          if (response == null) return;
          widget.addListingFormCubit.updateListingID(response.result.listingId);
          await uploadImages(images);
        }else{
          await uploadImages(images);
        }
      },
    );
  }

  Future<void> onImageSelected({required String filePath}) async {
    await widget.addListingFormCubit.onFieldsImagesChanged(
      imageControlID: widget.imageControlID,
      imageControlLabel: widget.imageControlLabel,
      key: widget.from,
      imagePath: filePath,
      multiImageSupported: widget.multiFileSupport,
    );
  }

  Future<void> uploadImages(List<XFile?>? images) async {
    if (images != null || images!.isNotEmpty) {
      for (var image in images) {
        await onImageSelected(filePath: image!.path);
      }
    } else {
      AppUtils.showErrorSnackBar(AppConstants.somethingWentWrong);
    }
  }
}
