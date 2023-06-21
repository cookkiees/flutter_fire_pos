import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final stockController = TextEditingController();
  final basicController = TextEditingController();
  final sellingController = TextEditingController();

  Stream<List<Product>> getProductStream() {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<Product>> getProductsByCategoryStream(String category) {
    return _productsCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

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

      final QuerySnapshot duplicateSnapshot = await _productsCollection
          .where('name', isEqualTo: product.name)
          .limit(1)
          .get();

      if (duplicateSnapshot.docs.isNotEmpty) {
        _duplicateProductName = "${product.name} is allready exist";
        notifyListeners();
        return;
      }
      Get.back();
      resetFields();
      final QuerySnapshot snapshot = await _productsCollection.get();
      final productIds = snapshot.docs.length;
      final id = productIds + 1;

      final DocumentReference documentReference =
          _productsCollection.doc('$id');

      await documentReference.set(product.toJson());

      await documentReference.update({'id': '$id'});
    } catch (error) {
      // Handle error
      debugPrint('Error adding product: $error');
    }
  }

  Stream<List<String>> getCategoriesStream() {
    return _categoriesCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>?)
          .where((data) => data != null && data.containsKey('categoryName'))
          .map((data) => data!['categoryName'] as String)
          .toList();
    });
  }

  String? selectedCategory;

  void updateSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  final List<String> _categories = [];
  List<String> get categories => _categories;

  Future<List<String>> getCategories() async {
    try {
      final QuerySnapshot snapshot = await _categoriesCollection.get();
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

  Future<void> addCategory(String categoryName) async {
    _errorCategories = '';
    if (categoryName.isEmpty) {
      _errorCategories = 'Category is required';
      notifyListeners();
      return;
    }

    try {
      final QuerySnapshot snapshot = await _categoriesCollection.get();
      final categoryIds = snapshot.docs.length;
      final id = categoryIds + 1;
      final categoryDocument = _categoriesCollection.doc('$id');

      await categoryDocument.set({
        'categoryName': categoryName,
        'id': '$id',
      });
      _categories.add(categoryName);
      notifyListeners();
    } catch (error) {
      // Handle error
      debugPrint('Error adding category: $error');
    }
  }
}
