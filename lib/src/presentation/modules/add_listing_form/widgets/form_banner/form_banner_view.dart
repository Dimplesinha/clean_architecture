import 'package:flutter/material.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/widgets/form_banner/model/progress_model.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';

class ListingFormBannerView extends StatelessWidget {
  final Progress? progress;
  final CategoriesListResponse? category;
  final AddListingFormLoadedState state;

  const ListingFormBannerView({super.key, required this.progress, this.category, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.profileTileBgColor,
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress?.progressPercentage,
                  strokeWidth: 4,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Center(
                  child: Text(
                    '${progress?.currentStep}/${progress?.totalSteps}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Text for basic details
          getCurrentAndNextPage(state,context)
        ],
      ),
    );
  }

  Widget getCurrentAndNextPage(AddListingFormLoadedState state, BuildContext context) {
    List<Sections>? sectionList = state.sections;
    if (sectionList == null || sectionList.isEmpty) {
      return const SizedBox.shrink();
    }

    int currentStep = (state.currentSectionCount ?? 1) - 1;
    int totalSteps = state.totalSectionCount ?? sectionList.length;

    return SizedBox(
      width: MediaQuery.of(context).size.width - 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// Display current section name
          Text(
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            sectionList[currentStep].sectionName ?? '',
            style: FontTypography.listingFormTitleStyle,
          ),
          sizedBox5Height(),

          /// Display next section name or completion message
          currentStep + 1 < totalSteps
              ? Text(
                  'Next: ${sectionList[currentStep + 1].sectionName ?? ""}',
                  style: FontTypography.listingFormSubTitleStyle,
                )
              : Text(
                  AddListingFormConstants.aboutToComplete,
                  style: FontTypography.listingFormSubTitleStyle,
                ),
        ],
      ),
    );
  }
}
