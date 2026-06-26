class VehicleOption {
  const VehicleOption({
    required this.categoryLabel,
    required this.name,
    required this.luggageLabel,
    required this.passengersLabel,
    required this.priceLabel,
    required this.imageAsset,
    this.starCount = 5,
  });

  final String categoryLabel;
  final String name;
  final String luggageLabel;
  final String passengersLabel;
  final String priceLabel;
  final String imageAsset;
  final int starCount;
}
