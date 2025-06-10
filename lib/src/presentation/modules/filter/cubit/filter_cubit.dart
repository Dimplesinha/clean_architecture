import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/domain/models/categories.dart';
import 'package:workapp/src/domain/models/ratings.dart';

part 'filter_state.dart';

///Cubit for state management and all method calling
class FilterCubit extends Cubit<FilterState> {
  List<Category> categories = [];
  List<Rating> ratings = [];
  bool selectAllCategories = false;
  bool selectAllRating = false;

  List<Category> selectedCategories = [];


  FilterCubit() : super(FilterInitial());

  void init() async {
    categories = [
      Category(title: 'Business', isSelected: false),
      Category(title: 'Workers', isSelected: false),
      Category(title: 'Real Estate', isSelected: false),
      Category(title: 'Jobs', isSelected: false),
      Category(title: 'Auto', isSelected: false),
      Category(title: 'Community', isSelected: false),
      Category(title: 'Events', isSelected: false),
      Category(title: 'Classifieds', isSelected: false),
      Category(title: 'Wanted', isSelected: false),
      Category(title: 'RV', isSelected: false),
      Category(title: 'Find People', isSelected: false),
    ];
    ratings = [
    Rating(value: '1 Start', isSelected: false),
    Rating(value: '2 Star', isSelected: false),
    Rating(value: '3 Star', isSelected: false),
    Rating(value: '4 Star', isSelected: false),
    Rating(value: '5 Star', isSelected: false),
    ];
    emit(FilterLoadedState());
  }

  void onCategorySelect() async {
    var oldState = state as FilterLoadedState;
    try {
      emit(oldState.copyWith(
        isCategorySelected: true,
        isClosetSelected: false,
        isFreshestSelected: false,
        isRatingSelected: false,
      ));
    } catch (e) {
      emit(FilterLoadedState());
    }
  }

  void onFreshestSelect() async {
    var oldState = state as FilterLoadedState;
    try {
      emit(oldState.copyWith(isCategorySelected: false,
        isClosetSelected: false,
        isFreshestSelected: true,
        isRatingSelected: false,));
    } catch (e) {
      emit(FilterLoadedState());
    }
  }

  void onClosestSelect() async {
    var oldState = state as FilterLoadedState;
    try {
      emit(oldState.copyWith(isCategorySelected: false,
        isClosetSelected: true,
        isFreshestSelected: false,
        isRatingSelected: false,));
    } catch (e) {
      emit(FilterLoadedState());
    }
  }

  void onRatingSelect() async {
    var oldState = state as FilterLoadedState;
    try {
      emit(oldState.copyWith(isCategorySelected: false,
        isClosetSelected: false,
        isFreshestSelected: false,
        isRatingSelected: true,));
    } catch (e) {
      emit(FilterLoadedState());
    }
  }

  void toggleCategorySelection(int index) {
    final selectedCategories = categories[index];
    selectedCategories.isSelected = !selectedCategories.isSelected;
    emit(state); // Emit a new state to trigger a rebuild
  }

  void toggleRatingSelection(int index) {
    final selectedRating = ratings[index];
    selectedRating.isSelected = !selectedRating.isSelected;
    emit(state); // Emit a new state to trigger a rebuild
  }

  void toggleSelectAllCategories() {
    selectAllCategories = !selectAllCategories;
    if (selectAllCategories) {
      // Select all categories
      for (var category in categories) {
        category.isSelected = true;
      }
    } else {
      // Deselect all categories
      for (var category in categories) {
        category.isSelected = false;
      }
    }
    emit(state);
  }

  void toggleSelectAllRating() {
    selectAllRating = !selectAllRating;
    if (selectAllRating) {
      // Select all categories
      for (var rating in ratings) {
        rating.isSelected = true;
      }
    } else {
      // Deselect all categories
      for (var rating in ratings) {
        rating.isSelected = false;
      }
    }
    emit(state);
  }
}
