import 'package:flutter/material.dart';
import '../db/shop_model.dart';

class ShopProvider extends ChangeNotifier {
  List<Product> shopdb = [
    Product(
      category: 'Headphones',
      cost: 270,
      description: 'New speaker',
      name: 'Wh-700 Max',
      imagePath: 'assets/headphone.jpg',
    ),
    Product(
      category: 'Microphones',
      cost: 150,
      description: 'High quality microphone',
      name: 'Micro Max',
      imagePath: 'assets/microphone.jpg',
    ),
    Product(
      category: 'Televisions',
      cost: 500,
      description: '4K Ultra HD TV',
      name: 'Ultra HD TV',
      imagePath: 'assets/tv.jpg',
    ),
    Product(
      category: 'Graphics Cards',
      cost: 300,
      description: 'High performance graphics card',
      name: 'GTX 1080',
      imagePath: 'assets/gtx.jpg',
    ),
  ];

  List<Product> cartdb = [];
  String _searchQuery = '';

  List<Product> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return shopdb;
    }
    return shopdb.where((product) {
      final query = _searchQuery.toLowerCase();
      return product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void addToCart(int index) {
    cartdb.add(shopdb[index]);
    notifyListeners();
  }

  void removeFromCart(int index) {
    cartdb.removeAt(index);
    notifyListeners();
  }

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
