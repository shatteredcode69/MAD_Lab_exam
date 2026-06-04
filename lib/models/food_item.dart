class FoodItem {
  final String name;
  final String price;
  final String rating;
  final String image;

  FoodItem({
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      rating: json['rating'] ?? '',
      image: json['image'] ?? '',
    );
  }
}