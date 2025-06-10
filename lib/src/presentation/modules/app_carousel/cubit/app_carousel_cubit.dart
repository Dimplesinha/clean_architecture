import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/app_carousel/app_carousel_exports.dart';
import 'package:workapp/src/presentation/modules/app_carousel/repo/app_carousel_repo.dart';


part 'app_carousel_state.dart';

class AppCarouselCubit extends Cubit<AppCarouselState> {
  AppCarouselRepository appCarouselRepository;

  AppCarouselCubit({required this.appCarouselRepository}) : super(AppCarouselInitial());

  void init() {
    emit(const AppCarouselLoadedState());
  }

  onCarouselPageChange({required int currentIndex}) {
    var oldState = state as AppCarouselLoadedState;
    emit(oldState.copyWith(items: oldState.items, currentIndex: currentIndex));
  }

  Future<MyListingResponse?> fetchItems({
    bool isFromChangedCategory = false,
    bool isRefresh = false,
    bool isFromInitialCall = false,
    String? visibilityTypeName,
  }) async {
    try {
      var oldState = state as AppCarouselLoadedState;

      var latLong = await AppUtils.getLatLong();

      /// [locationTypeStream] Will be used to update the location at dashboard
      String? categoryListingIds;
      var categoryList = await PreferenceHelper.instance.getCategoryList();
      var premiumListingData = await PreferenceHelper.instance.getPremiumListingData();
      categoryListingIds = categoryList.result?.map((category) => category.formId.toString())
          .where((id) => id.isNotEmpty)
          .join(',') ??
          '';

      if( premiumListingData.result!=null && premiumListingData.result!.isNotEmpty){
        List<MyListingItems> listingItems =
        (premiumListingData.result?.expand((model) => model.items ?? []).toList() ?? []).cast<MyListingItems>();
        emit(oldState.copyWith(items: listingItems));
      }

      Map<String, dynamic> requestBody = {
        ModelKeys.latitude: latLong[ModelKeys.latitude],
        ModelKeys.longitude: latLong[ModelKeys.longitude],
        ModelKeys.visibilityType: 1,
        ModelKeys.categoryId: categoryListingIds,
      };
      var response = await appCarouselRepository.fetchListingData(requestBody: requestBody);

      if (response.responseData?.statusCode == 200 && response.responseData != null) {

        PreferenceHelper.instance.setPremiumListingData(response.responseData);

        List<MyListingItems> listingItems =
        (response.responseData?.result?.expand((model) => model.items ?? []).toList() ?? []).cast<MyListingItems>();

        emit(oldState.copyWith(items: listingItems));

      }
      return response.responseData;
    } catch (e) {
      var oldState = state as AppCarouselLoadedState;
      emit(oldState.copyWith(items: []));
      return null;
    }
  }
}
