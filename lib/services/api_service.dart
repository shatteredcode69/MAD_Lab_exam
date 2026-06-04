import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

/// Handles network requests to fetch food items from webhook URL.
class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  /// Fetches food items from the webhook endpoint.
  /// Throws an exception if the request fails.
  Future<List<FoodItem>> fetchFoodItems() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((item) => FoodItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}