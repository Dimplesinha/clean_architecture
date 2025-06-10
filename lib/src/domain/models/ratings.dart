class Rating {
  final String value;
  bool isSelected;

  Rating({required this.value, this.isSelected = false});

  Rating copyWith({String? value, bool? isSelected}) {
    return Rating(
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}