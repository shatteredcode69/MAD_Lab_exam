import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/api_service.dart';
import '../widgets/food_card.dart';
import 'food_details_screen.dart';
import 'add_admin_screen.dart';

/// Home screen – displays search bar and filtered list of food items.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variables
  List<FoodItem> _allItems = [];
  List<FoodItem> _filteredItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  final String _webhookUrl =
      "https://webhook.site/586b3145-e5f0-4b36-99c9-f5ccf778ad8a";

  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(baseUrl: _webhookUrl);
    _fetchData();
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  /// Fetches food items from API and updates state.
  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final items = await _apiService.fetchFoodItems();
      if (!mounted) return;
      setState(() {
        _allItems = items;
        _filteredItems = items; // Show all items initially
        _isLoading = false;
      });
      // No need to call _filterItems() here because _filteredItems already equals _allItems
      // The search bar might already have text, so we re-filter:
      _filterItems();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Filters items based on search query (case-insensitive).
  void _filterItems() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(_allItems);
      } else {
        _filteredItems = _allItems.where((item) {
          return item.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Menu'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.orange),
                child: Text('Menu',
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Add Admin'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddAdminScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by food name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchData, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_filteredItems.isEmpty) {
      return const Center(child: Text('No matching food items found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return FoodCard(
          item: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FoodDetailsScreen(foodItem: item),
              ),
            );
          },
        );
      },
    );
  }
}
