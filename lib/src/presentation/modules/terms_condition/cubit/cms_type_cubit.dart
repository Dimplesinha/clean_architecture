import 'package:equatable/equatable.dart';
import 'package:workapp/src/domain/models/cms_model.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/terms_condition/repository/cms_repository.dart';

part 'cms_type_state.dart';

class CmsTypeCubit extends Cubit<CmsTypeState> {
  CmsTypeCubit() : super(const CmsTypeLoadedState());

  void init({required int cmsTypeId}) async {
    await fetchCmsTypeData(cmsTypeId: cmsTypeId);
  }

  Future<void> fetchCmsTypeData({required int cmsTypeId}) async {
    var oldState = state as CmsTypeLoadedState;
    try {
      emit(oldState.copyWith(isLoading: true));
      var response = await CmsTypeRepository.instance.fetchCMSContent(cmsTypeId: cmsTypeId);
      if (response.status) {
        CMSTypeModel? cmsData = response.responseData;
        emit(oldState.copyWith(isLoading: false, cmsTypeModel: cmsData));
      } else {
        emit(oldState.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(oldState.copyWith(isLoading: false));
    }
  }
}
