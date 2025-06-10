import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/image_preview.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/cubit/add_listing_form_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/business_logo_widget.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/image_list_widget.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/listing_form_image_picker.dart';
import 'package:workapp/src/presentation/modules/app_carousel/app_carousel_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/add_listing_form_utils/listing_form_utils.dart';

class BusinessImagesFormView extends StatefulWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const BusinessImagesFormView({super.key, required this.addListingFormCubit, required this.state});

  @override
  State<BusinessImagesFormView> createState() => _BusinessImagesFormViewState();
}

class _BusinessImagesFormViewState extends State<BusinessImagesFormView> {
  @override
  Widget build(BuildContext context) {
    var maxMediaCount = AddListingFormUtils.getBusinessImagesMaximumCount(categoryName: widget.state.category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelText(
            title: AddListingFormConstants.uploadHomePageLogo,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.state.formDataMap?[AddListingFormConstants.uploadHomePageLogo] == null,
                replacement: widget.state.businessLogo != null
                    ? GestureDetector(
                        onTap: () {
                          List<String> list = [];
                          list.add( widget.state.businessLogo!);
                          showDialog(
                            barrierDismissible: false,
                            context: navigatorKey.currentState!.context,
                            builder: (BuildContext context) {
                              return ImagePreview(
                                imageList: list,
                                selectedIndex: 0,
                              );
                            },
                          );
                        },
                        child: BusinessLogoWidget(
                          networkImagePath: widget.state.businessLogo ?? '',
                          onDeleteItemClick: () {
                            widget.addListingFormCubit.onFieldsImageDeleted(
                              key: AddListingFormConstants.uploadHomePageLogo,
                              imagePath: widget.state.businessLogo!,
                              multiImageSupported: false,
                            );
                          },
                          isUploading: widget.state.isBusinessLogoUploading ?? false,
                        ),
                      )
                    : const SizedBox(),
                child: ListingFormImagePicker(
                  from: AppConstants.profile,
                  selectedMediaSize: widget.state.imageModelList?.length ?? 0,
                  addListingFormCubit: widget.addListingFormCubit,
                  state: widget.state,
                  label: AddListingFormConstants.uploadHomePageLogo,
                  multiFileSupport: true,
                ),
              ),
              sizedBox20Width(),
              Flexible(
                child: Text(
                  AddListingFormConstants.uploadImageMsg,
                  style: FontTypography.listingStatTxtStyle,
                ),
              ),
            ],
          ),
          sizedBox20Height(),
          LabelText(
            title: AddListingFormConstants.uploadPhotosAndVideos,
            textStyle: FontTypography.subTextStyle,
            isRequired: false,
          ),
          LabelText(
            title: AddListingFormConstants.uploadUpToMsg.replaceAll(
              '{maxUploadCount}',
              maxMediaCount.toString(),
            ),
            textStyle: FontTypography.listingStatTxtStyle,
            isRequired: false,
            maxLines: 4,
            padding: const EdgeInsets.only(bottom: 20),
          ),
          sizedBox10Height(),
          CreateGalleryWidget(
            filesMap: widget.state.formDataMap?[AddListingFormConstants.uploadPhotosAndVideos],
            addListingFormCubit: widget.addListingFormCubit,
            state: widget.state,
            mediaListModel: widget.state.imageModelList,
            maxSelectionLimit: maxMediaCount,
          ),
        ],
      ),
    );
  }
}
