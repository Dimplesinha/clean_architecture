import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/cubit/google_location_view_cubit.dart';
import 'package:workapp/src/presentation/style/style.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';

class GoogleLocationViewBottomSheet extends StatelessWidget {
  /// [locationController] should be used in any view apart from add listing forms
  final TextEditingController? locationController;
  final String? selectedAddress;

  /// [onLocationChanged] should be used in add listing forms
  final Function(Map<String, String?>? json)? onLocationChanged;

  /// [selectedLocation] should be used in add listing forms
  final String? selectedLocation;
  final GoogleLocationViewCubit? googleLocationViewCubit;
  final Function()? onClearLocation;

  const GoogleLocationViewBottomSheet({
    super.key,
    this.locationController,
    this.onLocationChanged,
    this.selectedLocation,
    this.googleLocationViewCubit,
    this.selectedAddress,
    this.onClearLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoogleLocationViewCubit, GoogleLocationViewState>(
      bloc: googleLocationViewCubit,
      builder: (context, state) {
        if (state is GoogleLocationViewLoaded) {
          return Container(
            height: MediaQuery.of(context).viewInsets.bottom > 0.0
                ? (MediaQuery.of(context).size.height * 0.8 - MediaQuery.of(context).viewInsets.bottom)
                : MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width / 16),
                      Expanded(
                        child: Center(
                          child: Text(
                            AppConstants.searchLocationStr,
                            style: FontTypography.textFieldsValueStyle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => AppRouter.pop(),
                          child: Icon(Icons.close, color: AppColors.jetBlackColor, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    AppConstants.searchLocationFromListStr,
                    style: FontTypography.listingFormSubTitleStyle,
                  ),
                ),
                sizedBox10Height(),
                AppTextField(
                  hintTxt: AppConstants.locationHintStr,
                  controller: locationController,
                  textInputAction: TextInputAction.search,
                  suffixIcon: Visibility(
                    visible: selectedLocation?.isNotEmpty ?? locationController?.text.isNotEmpty ?? false,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.cancel_outlined, size: 20),
                      onPressed: () => onClearLocation?.call(),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length >= 3) {
                      googleLocationViewCubit?.fetchSuggestion(input: value);
                    }
                  },
                ),
                Flexible(
                  child: Visibility(
                    visible: state.placesList?.isNotEmpty ?? false,
                    replacement: const SizedBox.shrink(),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.placesList?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.maybePop(context, {'selected_place': state.placesList?[index]});
                          },
                          child: ListTile(
                            title: Text(state.placesList?[index].description ?? ''),
                            trailing: Visibility(
                              visible: (state.placesList?[index].description ?? '').toLowerCase() ==
                                  selectedAddress?.toLowerCase(),
                              child: Icon(Icons.check_box_outlined, color: AppColors.primaryColor),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
