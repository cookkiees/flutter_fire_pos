import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final _productsCollection = FirebaseFirestore.instance.collection('products');
  final _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final stockController = TextEditingController();
  final basicController = TextEditingController();
  final sellingController = TextEditingController();

  String _duplicateProductName = '';
  String get duplicateProductName => _duplicateProductName;

  String _errorName = '';
  String get errorName => _errorName;

  String _errorCategories = '';
  String get errorCategories => _errorCategories;

  String _errorStock = '';
  String get errorStock => _errorStock;

  String _errorSellingPrice = '';
  String get errorSellingPrice => _errorSellingPrice;

  String _errorBasicPrice = '';
  String get errorBasicPrice => _errorBasicPrice;
  void resetFields() {
    _duplicateProductName = '';
    _errorName = '';
    _errorCategories = '';
    _errorStock = '';
    _errorSellingPrice = '';
    _errorBasicPrice = '';
    nameController.clear();
    stockController.clear();
    categoryController.clear();
    sellingController.clear();
    basicController.clear();
    notifyListeners();
  }

  void validate() {
    _errorName = _validateField(nameController, 'Name');
    _errorCategories = _validateField(categoryController, 'Category');
    _errorStock = _validateField(stockController, 'Stock');
    _errorSellingPrice = _validateField(sellingController, 'Selling price');
    _errorBasicPrice = _validateField(basicController, 'Basic price');

    notifyListeners();
  }

  String _validateField(TextEditingController controller, String fieldName) {
    final String value = controller.text.trim();
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return '';
  }

  Future<void> addProduct() async {
    validate();

    if (_errorName.isNotEmpty ||
        _errorCategories.isNotEmpty ||
        _errorStock.isNotEmpty ||
        _errorSellingPrice.isNotEmpty ||
        _errorBasicPrice.isNotEmpty) {
      notifyListeners();
      return;
    }
    try {
      final category = categoryController.text;
      final categories = await getCategories();
      if (!categories.contains(category)) {
        await addCategory(category);
      }

      final product = Product(
        name: nameController.text,
        category: category,
        stock: int.tryParse(stockController.text) ?? 0,
        sellingPrice: int.tryParse(sellingController.text) ?? 0,
        basicPrice: int.tryParse(basicController.text) ?? 0,
      );
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;
      final QuerySnapshot duplicateSnapshot = await _productsCollection
          .doc(userEmail)
          .collection('list products')
          .where('name', isEqualTo: product.name)
          .limit(1)
          .get();

      if (duplicateSnapshot.docs.isNotEmpty) {
        _duplicateProductName = "${product.name} is allready exist";
        notifyListeners();
        return;
      }

      final QuerySnapshot snapshot = await _productsCollection
          .doc(userEmail)
          .collection('list products')
          .get();
      final categoryDocs = snapshot.docs;

      int maxId = 0;
      for (var doc in categoryDocs) {
        final id = int.tryParse(doc['id']);
        if (id != null && id > maxId) {
          maxId = id;
        }
      }
      final newId = (maxId + 1).toString();

      final DocumentReference documentReference = _productsCollection
          .doc(userEmail)
          .collection('list products')
          .doc(newId);
      await documentReference.set(product.toJson());
      await documentReference.update({'id': newId});
      final Product newProduct = Product(
        id: newId,
        name: nameController.text,
        category: category,
        stock: int.tryParse(stockController.text) ?? 0,
        sellingPrice: int.tryParse(sellingController.text) ?? 0,
        basicPrice: int.tryParse(basicController.text) ?? 0,
      );

      _products.add(newProduct);

      getFilteredProducts();
      resetFields();

      Get.back();
    } catch (error) {
      // Handle error
      debugPrint('Error adding product: $error');
    }
  }

  final List<String> _categories = [];
  List<String> get categories => _categories;

  Future<List<String>> getCategories() async {
    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;

      final QuerySnapshot snapshot = await _categoriesCollection
          .doc(userEmail)
          .collection('list category')
          .get();
      final List<String> newCategories = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>?)
          .where((data) => data != null && data.containsKey('categoryName'))
          .map((data) => data!['categoryName'] as String)
          .toList();

      _categories.clear();
      _categories.addAll(newCategories);

      notifyListeners();

      return _categories;
    } catch (error) {
      // Handle error
      debugPrint('Error getting categories: $error');
      return [];
    }
  }

  int getProductCountByCategory(String category) {
    if (selectedCategory == category) {
      return filteredProducts.length;
    } else {
      return _products.where((product) => product.category == category).length;
    }
  }

  String? selectedCategory;

  void updateSelectedCategory(String category) {
    selectedCategory = category;
    getFilteredProducts();
    notifyListeners();
  }

  List<Product> filteredProducts = [];

  List<Product> getFilteredProducts() {
    if (selectedCategory != null) {
      filteredProducts = products
          .where((product) => product.category == selectedCategory)
          .toList();
      return filteredProducts;
    } else {
      return filteredProducts = products;
    }
  }

  final List<Product> _products = [];
  List<Product> get products => _products;

  Future<List<Product>> getProducts() async {
    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;

      final QuerySnapshot snapshot = await _productsCollection
          .doc(userEmail)
          .collection('list products')
          .get();
      final List<Product> newProducts = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>?)
          .where((data) => data != null && data.containsKey('id'))
          .map((data) => Product(
                id: data!['id'] as String?,
                name: data['name'] as String,
                category: data['category'] as String,
                stock: data['stock'] as int,
                sellingPrice: data['sellingPrice'] as int,
                basicPrice: data['basicPrice'] as int,
                quantity: data['quantity'] as int? ?? 0,
              ))
          .toList();

      _products.clear();
      _products.addAll(newProducts);
      getFilteredProducts();

      notifyListeners();

      return _products;
    } catch (error) {
      // Handle error
      debugPrint('Error getting categories: $error');
      return [];
    }
  }

  Future<void> addCategory(String categoryName) async {
    _errorCategories = '';
    if (categoryName.isEmpty) {
      _errorCategories = 'Category is required';
      notifyListeners();
      return;
    }

    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;

      final QuerySnapshot snapshot = await _categoriesCollection
          .doc(userEmail)
          .collection('list category')
          .get();
      final categoryDocs = snapshot.docs;

      int maxId = 0;
      for (var doc in categoryDocs) {
        final id = int.tryParse(doc['id']);
        if (id != null && id > maxId) {
          maxId = id;
        }
      }
      final newId = (maxId + 1).toString();

      final categoryDocument = _categoriesCollection
          .doc(userEmail)
          .collection('list category')
          .doc(newId);

      await categoryDocument.set({
        'categoryName': categoryName,
        'id': newId,
      });

      getFilteredProducts();
      _categories.add(categoryName);
      notifyListeners();
    } catch (error) {
      // Handle error
      debugPrint('Error adding category: $error');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;
      final DocumentReference documentReference = _productsCollection
          .doc(userEmail)
          .collection('list products')
          .doc(productId);
      await documentReference.delete();

      _products.removeWhere((product) => product.id == productId);
      getFilteredProducts();
      notifyListeners();
    } catch (error) {
      // Handle error
      debugPrint('Error deleting product: $error');
    }
  }

  Future<void> updateStock(
      String productId, TextEditingController quantityController) async {
    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;

      final DocumentReference documentReference = _productsCollection
          .doc(userEmail)
          .collection('list products')
          .doc(productId);

      // Retrieve the current stock of the product
      final DocumentSnapshot snapshot = await documentReference.get();
      final int currentStock = snapshot['stock'] as int;

      // Get the updated stock quantity from the quantityController
      final int quantity = int.tryParse(quantityController.text) ?? 0;

      // Calculate the new stock value
      final int updatedStock = currentStock + quantity;

      // Update the stock of the product
      await documentReference.update({'stock': updatedStock});

      // Update the stock in the local list of products
      final index = _products.indexWhere((product) => product.id == productId);
      if (index != -1) {
        final Product updatedProduct =
            _products[index].copyWith(stock: updatedStock);
        _products[index] = updatedProduct;
      }

      getFilteredProducts();
      Get.back();
      notifyListeners();
    } catch (error) {
      // Handle error
      debugPrint('Error updating stock: $error');
    }
  }
}
