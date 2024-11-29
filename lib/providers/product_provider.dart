import 'package:flutter/foundation.dart';
import 'package:lulu/models/product.dart';
import 'package:lulu/services/firebase_service.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _firebaseService.getProducts().listen((products) {
        _products = products;
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    await _firebaseService.createProduct(product);
  }

  Future<void> updateProduct(Product product) async {
    await _firebaseService.updateProduct(product);
  }

  Future<void> deleteProduct(String productId) async {
    await _firebaseService.deleteProduct(productId);
  }
} 