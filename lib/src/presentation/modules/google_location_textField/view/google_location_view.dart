import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/domain/models/google_location_model.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/cubit/google_location_view_cubit.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/repo/google_location_repo.dart';
import 'package:workapp/src/presentation/modules/google_location_textField/view/address_listing_bottom_sheet.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/utils.dart';

class GoogleLocationView extends StatefulWidget {
  /// [locationController] should be used in any view apart from add listing forms
  final TextEditingController? locationController;

  /// [onLocationChanged] should be used in add listing forms
  final Function(Map<String, String?>? json)? onLocationChanged;

  /// [selectedLocation] should be used in add listing forms
  final String? selectedLocation;
  final String? hintText;

  const GoogleLocationView({
    super.key,
    this.locationController,
    this.onLocationChanged,
    this.selectedLocation,
    this.hintText,
  });

  @override
  State<GoogleLocationView> createState() => _GoogleLocationViewState();
}

class _GoogleLocationViewState extends State<GoogleLocationView> {
  final GoogleLocationViewCubit googleLocationViewCubit = GoogleLocationViewCubit(
    fetchGoogleLocationRepo: FetchGoogleLocationRepo.instance,
  );

  late final TextEditingController? _locationController;

  void initialiseLocationController() {
    _locationController = widget.locationController ?? TextEditingController(text: widget.selectedLocation);
  }

  @override
  void initState() {
    initialiseLocationController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoogleLocationViewCubit, GoogleLocationViewState>(
      bloc: googleLocationViewCubit,
      builder: (context, state) {
        if (state is GoogleLocationViewLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppTextField(
                isReadOnly: true,
                onTap: () => _openBottomSheetBottom(),
                hintTxt: widget.hintText ?? AppConstants.locationHintStr,
                controller: _locationController,
                suffixIcon: Visibility(
                  visible: widget.selectedLocation?.isNotEmpty ?? _locationController?.text.isNotEmpty ?? false,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.cancel_outlined, size: 20),
                    onPressed: () => clearLocation(),
                  ),
                ),
                onChanged: (value) {},
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void clearLocation() {
    if (widget.onLocationChanged != null) {
      widget.onLocationChanged?.call(null);
    }
    googleLocationViewCubit.onLocationCleared();
    _locationController?.clear();
  }

  Future<void> _openBottomSheetBottom() async {
    Map<String, dynamic>? res = await AppUtils.showBottomSheet(
      navigatorKey.currentState!.context,
      child: GoogleLocationViewBottomSheet(
        selectedAddress: _locationController?.text,
        locationController: widget.locationController,
        googleLocationViewCubit: googleLocationViewCubit,
        onClearLocation: clearLocation,
      ),
    );
    if (res != null) {
      PlacePrediction? selectedPlace = res['selected_place'];
      _locationController?.text = selectedPlace?.description ?? '';
      String? placeId = selectedPlace?.placeId;
      if (placeId != null) {
        Map<String, String> latLongMap = await googleLocationViewCubit.fetchLatLongFromAddressPlaceId(placeId: placeId);
        if (widget.onLocationChanged != null) {
          latLongMap[ModelKeys.description] = selectedPlace?.description ?? '';
          widget.onLocationChanged?.call(latLongMap);
        }
      }

      googleLocationViewCubit.onLocationSelected();
    }
  }
}
