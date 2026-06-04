import 'package:flutter/material.dart';
import '../models/food_item.dart';

/// Detailed view of a single food item.
class FoodDetailsScreen extends StatelessWidget {
  final FoodItem foodItem;

  const FoodDetailsScreen({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodItem.name),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: foodItem.image,
              child: Image.network(
                foodItem.image,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 80),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(foodItem.name,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Icon(Icons.attach_money, size: 24),
                    Text(foodItem.price,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.green))
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Icon(Icons.star, color: Colors.amber, size: 28),
                    const SizedBox(width: 8),
                    Text(foodItem.rating, style: const TextStyle(fontSize: 22)),
                    const Text('/ 5',
                        style: TextStyle(fontSize: 16, color: Colors.grey))
                  ]),
                  const SizedBox(height: 24),
                  const Divider(),
                  const Text('Description',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                      'A delicious ${foodItem.name.toLowerCase()} prepared with the finest ingredients. Perfect for any meal of the day.',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
