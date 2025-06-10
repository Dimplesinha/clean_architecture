part of 'google_location_view_cubit.dart';

sealed class GoogleLocationViewState extends Equatable {
  const GoogleLocationViewState();
}

final class GoogleLocationViewInitial extends GoogleLocationViewState {
  @override
  List<Object?> get props => [];
}

final class GoogleLocationViewLoaded extends GoogleLocationViewState {
  final List<PlacePrediction>? placesList;

  const GoogleLocationViewLoaded({this.placesList});

  @override
  List<Object?> get props => [placesList, identityHashCode(this)];

  GoogleLocationViewLoaded copyWith({List<PlacePrediction>? placesList}) {
    return GoogleLocationViewLoaded(placesList: placesList ?? this.placesList);
  }
}
