import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/image_preview.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/business_logo_widget.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/image_list_widget.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/listing_form_image_picker.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/utils/add_listing_form_utils/listing_form_utils.dart';

class PromoPhotosVideosFormView extends StatelessWidget {
  final AddListingFormCubit addListingFormCubit;
  final AddListingFormLoadedState state;

  const PromoPhotosVideosFormView({super.key, required this.addListingFormCubit, required this.state});

  @override
  Widget build(BuildContext context) {

    var maxMediaCount = AddListingFormUtils.getBusinessImagesMaximumCount(categoryName: state.category);

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
                visible: state.formDataMap?[AddListingFormConstants.uploadHomePageLogo] == null ? true : false,
                replacement: GestureDetector(
                  onTap: () {
                    List<String> list = [];
                    list.add(state.businessLogo!);
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
                    networkImagePath: state.businessLogo,
                    onDeleteItemClick: () {
                      addListingFormCubit.onFieldsImageDeleted(
                        key: AddListingFormConstants.uploadHomePageLogo,
                        imagePath: state.businessLogo ?? '',
                        multiImageSupported: false,
                      );
                    },
                    isUploading: state.isBusinessLogoUploading,
                  ),
                ),
                child: ListingFormImagePicker(
                  from: AppConstants.profile,
                  selectedMediaSize: state.imageModelList?.length ?? 0,
                  addListingFormCubit: addListingFormCubit,
                  state: state,
                  label: AddListingFormConstants.uploadHomePageLogo,
                  multiFileSupport: false,
                  maxMediaCount: maxMediaCount,
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
            filesMap: state.formDataMap?[AddListingFormConstants.uploadPhotosAndVideos],
            addListingFormCubit: addListingFormCubit,
            state: state,
            mediaListModel: state.imageModelList,
            maxSelectionLimit: maxMediaCount,
          ),
        ],
      ),
    );
  }
}
