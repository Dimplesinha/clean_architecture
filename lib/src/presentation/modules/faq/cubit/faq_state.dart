part of 'faq_cubit.dart';

final class FaqLoadedState extends Equatable {
  final bool isLoading;
  final List<FAQResult>? faqItemData;

  const FaqLoadedState({this.isLoading = false, this.faqItemData});

  @override
  List<Object?> get props => [isLoading, faqItemData];

  FaqLoadedState copyWith({bool? isLoading, List<FAQResult>? faqItemData}) {
    return FaqLoadedState(
      isLoading: isLoading ?? this.isLoading,
      faqItemData: faqItemData ?? this.faqItemData,
    );
  }
}
