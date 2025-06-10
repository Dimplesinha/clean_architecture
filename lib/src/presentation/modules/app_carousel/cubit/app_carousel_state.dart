part of 'app_carousel_cubit.dart';

sealed class AppCarouselState extends Equatable {
  const AppCarouselState();
}

final class AppCarouselInitial extends AppCarouselState {
  @override
  List<Object> get props => [];
}

final class AppCarouselLoadedState extends AppCarouselState {
  final List<MyListingItems>? items;
  final int currentIndex;
  final List<Widget>? sliderItems;
  final List<Widget>? indicatorItems;
  final Function()? onItemClick;

  const AppCarouselLoadedState(
      {this.items, this.currentIndex = 0, this.sliderItems, this.indicatorItems, this.onItemClick});

  @override
  List<Object?> get props => [
        items,
        currentIndex,
        sliderItems,
        indicatorItems,
        onItemClick,
      ];

  AppCarouselLoadedState copyWith(
      {List<MyListingItems>? items,
      int? currentIndex,
      List<Widget>? sliderItems,
      List<Widget>? indicatorItems,
      Function()? onItemClick}) {
    return AppCarouselLoadedState(
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      sliderItems: sliderItems ?? this.sliderItems,
      indicatorItems: indicatorItems ?? this.indicatorItems,
      onItemClick: onItemClick ?? this.onItemClick,
    );
  }
}
