import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/domain/models/faq_model.dart';
import 'package:workapp/src/presentation/modules/faq/repo/faq_repo.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqLoadedState> {
  final FAQRepo faqRepo;

  FaqCubit({required this.faqRepo}) : super(const FaqLoadedState());

  void init() async {
    emit(state.copyWith(isLoading: true));
    var response = await faqRepo.fetchFaqList();
    try {
      if (response?.responseData?.statusCode == 200 && response?.responseData != null) {
        emit(state.copyWith(isLoading: false, faqItemData: response?.responseData?.result));
      }
    } catch (e) {
      emit(state.copyWith(faqItemData: [], isLoading: false));
    }
  }
}
