import 'package:flutter/material.dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    
    Product(
      id: 'p1',
      title: 'Chicken',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'images/im1.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Chicken soupe',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl: 'images/im2.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Chicken s',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl: 'images/im3.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Burger',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl: 'images/im4.jpg',
    ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

   List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  //   void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();

  // }


  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere( (prod) => prod.id == id);
  }


}