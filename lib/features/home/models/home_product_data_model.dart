class ProductDataModel {
  final int id; // Change the type to int
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  ProductDataModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}