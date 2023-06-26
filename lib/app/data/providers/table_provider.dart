import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/consumer_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'product_provider.dart';

class TableProvider extends ChangeNotifier {
  String _sortColumnName = ''; // Kolom yang digunakan untuk pengurutan
  bool _isAscending = true; // Urutan (naik atau turun)

  String get sortColumnName => _sortColumnName;
  bool get isAscending => _isAscending;

  int _itemsPerPageProduct = 5;

  int get itemsPerPageProduct => _itemsPerPageProduct;

  void changeItemsPerPageProduct(int value) {
    _itemsPerPageProduct = value;
    _currentPageProduct = 0;
    notifyListeners();
  }

  int _currentPageProduct = 0;

  int get currentPageProduct => _currentPageProduct;

  void setCurrentPageProduct(int page) {
    _currentPageProduct = page;
    notifyListeners();
  }

  void goToPageProduct(int page) {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(Get.context!, listen: false);
    int totalPages =
        ((productProvider.products.length - 1) / _itemsPerPageProduct).ceil();
    if (page >= 0 && page < totalPages) {
      setCurrentPageProduct(page);
    }
    notifyListeners();
  }

  int get totalPagesProduct {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(Get.context!, listen: false);

    int totalItems = productProvider.products.length;
    int totalPages = (totalItems / _itemsPerPageProduct).ceil();

    return totalPages;
  }

  void sortProducts(String columnName) {
    // Fungsi untuk mengurutkan produk berdasarkan kolom yang dipilih
    if (_sortColumnName == columnName) {
      // Jika kolom yang sama di-klik lagi, ubah urutan
      _isAscending = !_isAscending;
    } else {
      // Jika kolom yang berbeda di-klik, urutan akan naik
      _sortColumnName = columnName;
      _isAscending = true;
    }

    ProductProvider productProvider =
        Provider.of<ProductProvider>(Get.context!, listen: false);

    switch (_sortColumnName) {
      case 'ID':
        productProvider.products.sort((a, b) {
          final int? idA = int.tryParse("${a.id}");
          final int? idB = int.tryParse("${b.id}");

          if (idA != null && idB != null) {
            return idA.compareTo(idB);
          } else {
            return 0;
          }
        });
        break;
      case 'Product Name':
        productProvider.products.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Category':
        productProvider.products
            .sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'Stock':
        productProvider.products.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case 'Selling Price':
        productProvider.products
            .sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
        break;
      case 'Basic Price':
        productProvider.products
            .sort((a, b) => a.basicPrice.compareTo(b.basicPrice));
        break;
      default:
        // Jika kolom tidak dikenali, tidak melakukan pengurutan
        break;
    }

    // Jika urutan turun, balikkan daftar produk
    if (!_isAscending) {
      productProvider.products == productProvider.products.reversed.toList();
    }

    notifyListeners();
  }

  int _itemsPerPageConsumer = 5;

  int get itemsPerPageConsumer => _itemsPerPageConsumer;

  void changeItemsPerPageConsumer(int value) {
    _itemsPerPageConsumer = value;
    _currentPageConsumer = 0;
    notifyListeners();
  }

  int _currentPageConsumer = 0;

  int get currentPageConsumer => _currentPageConsumer;

  void setCurrentPageConsumer(int page) {
    _currentPageConsumer = page;
    notifyListeners();
  }

  void goToPageConsumer(int page) {
    ConsumersProvider consumerProvider =
        Provider.of<ConsumersProvider>(Get.context!, listen: false);
    int totalPages =
        ((consumerProvider.listConsumers.length - 1) / _itemsPerPageConsumer)
            .ceil();
    if (page >= 0 && page < totalPages) {
      setCurrentPageConsumer(page);
    }
    notifyListeners();
  }

  int get totalPagesConsumer {
    ConsumersProvider consumerProvider =
        Provider.of<ConsumersProvider>(Get.context!, listen: false);

    int totalItems = consumerProvider.listConsumers.length;
    int totalPages = (totalItems / _itemsPerPageConsumer).ceil();

    return totalPages;
  }

  void sortConsumers(String columnName) {
    // Fungsi untuk mengurutkan produk berdasarkan kolom yang dipilih
    if (_sortColumnName == columnName) {
      // Jika kolom yang sama di-klik lagi, ubah urutan
      _isAscending = !_isAscending;
    } else {
      // Jika kolom yang berbeda di-klik, urutan akan naik
      _sortColumnName = columnName;
      _isAscending = true;
    }

    ConsumersProvider consumersProvider =
        Provider.of<ConsumersProvider>(Get.context!, listen: false);

    switch (_sortColumnName) {
      case 'ID':
        consumersProvider.listConsumers.sort((a, b) {
          final int? idA = int.tryParse(a.id);
          final int? idB = int.tryParse(b.id);

          if (idA != null && idB != null) {
            return idA.compareTo(idB);
          } else {
            return 0;
          }
        });
        break;
      case 'Name':
        consumersProvider.listConsumers
            .sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Address':
        consumersProvider.listConsumers
            .sort((a, b) => a.address.compareTo(b.address));
        break;
      case 'Phone Number':
        consumersProvider.listConsumers
            .sort((a, b) => a.phoneNumber.compareTo(b.phoneNumber));
        break;
      default:
        // Jika kolom tidak dikenali, tidak melakukan pengurutan
        break;
    }

    // Jika urutan turun, balikkan daftar produk
    if (!_isAscending) {
      consumersProvider.listConsumers ==
          consumersProvider.listConsumers.reversed.toList();
    }

    notifyListeners();
  }
}
