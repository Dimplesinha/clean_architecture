part of 'search_cubit.dart';

@immutable
sealed class SearchState extends Equatable {
  const SearchState();
}

final class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}

final class SearchLoadedState extends SearchState {
  final List<MyListingItems>? items;
  final MyListingResponse? searchResult;
  final bool loader;
  final String? address;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? advanceSearchFormData;

  const SearchLoadedState({
    this.items,
    this.searchResult,
    this.address,
    this.latitude,
    this.longitude,
    this.loader = false,
    this.advanceSearchFormData,
  });

  @override
  List<Object?> get props => [items, searchResult, loader, address, latitude, longitude, advanceSearchFormData];

  SearchLoadedState copyWith({
    List<MyListingItems>? items,
    bool? loader,
    String? address,
    MyListingResponse? searchResult,
    double? longitude,
    double? latitude,
    Map<String, dynamic>? advanceSearchFormData,
  }) {
    return SearchLoadedState(
      loader: loader ?? this.loader,
      searchResult: searchResult ?? this.searchResult,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      items: items ?? this.items,
      address: address ?? this.address,
      advanceSearchFormData: advanceSearchFormData ?? this.advanceSearchFormData,
    );
  }
}
