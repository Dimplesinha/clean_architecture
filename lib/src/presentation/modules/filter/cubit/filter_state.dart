part of 'filter_cubit.dart';

@immutable
sealed class FilterState extends Equatable {}

final class FilterInitial extends FilterState {
  @override
  List<Object?> get props => [];
}

final class FilterLoadedState extends FilterState {
  final bool isCategorySelected;
  final bool isClosetSelected;
  final bool isFreshestSelected;
  final bool isRatingSelected;
  final List<Category>? selectedCategories;
  final List<Rating>? ratings;

  FilterLoadedState(
      {this.isCategorySelected = true,
      this.isClosetSelected = false,
      this.isFreshestSelected = false,
      this.isRatingSelected = false,
      this.selectedCategories,
      this.ratings});

  @override
  List<Object?> get props => [
        isCategorySelected,
        isClosetSelected,
        isFreshestSelected,
        isRatingSelected,
        selectedCategories,
        ratings,
      ];

  FilterLoadedState copyWith({
    bool? isCategorySelected,
    bool? isClosetSelected,
    bool? isFreshestSelected,
    bool? isRatingSelected,
    List<Category>? selectedCategories,
    List<Rating>? ratings,
  }) {
    return FilterLoadedState(
      isCategorySelected: isCategorySelected ?? this.isCategorySelected,
      isClosetSelected: isClosetSelected ?? this.isClosetSelected,
      isFreshestSelected: isFreshestSelected ?? this.isFreshestSelected,
      isRatingSelected: isRatingSelected ?? this.isRatingSelected,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      ratings: ratings ?? this.ratings,
    );
  }
}
