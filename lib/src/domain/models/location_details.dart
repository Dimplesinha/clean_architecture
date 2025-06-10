class LocationDetails {
  final String? address;
  final String? city;
  final String? state;
  final String? country;

  LocationDetails({
    this.address,
    this.city,
    this.state,
    this.country,
  });

  @override
  String toString() {
    return 'Address: $address, City: $city, State: $state, Country: $country';
  }
}
