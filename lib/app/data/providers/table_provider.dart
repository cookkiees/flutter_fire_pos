import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'product_provider.dart';

class TableProvider extends ChangeNotifier {
  String _sortColumnName = ''; // Kolom yang digunakan untuk pengurutan
  bool _isAscending = true; // Urutan (naik atau turun)

  String get sortColumnName => _sortColumnName;
  bool get isAscending => _isAscending;

  int _itemsPerPage = 5;

  int get itemsPerPage => _itemsPerPage;

  void changeItemsPerPage(int value) {
    _itemsPerPage = value;
    _currentPage = 0;
    notifyListeners();
  }

  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void goToPage(int page) {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(Get.context!, listen: false);
    int totalPages =
        ((productProvider.products.length - 1) / itemsPerPage).ceil();
    if (page >= 0 && page < totalPages) {
      setCurrentPage(page);
    }
    notifyListeners();
  }

  int get totalPages {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(Get.context!, listen: false);

    int totalItems = productProvider.products.length;
    int totalPages = (totalItems / _itemsPerPage).ceil();

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
}
