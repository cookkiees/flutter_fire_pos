import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import 'product_provider.dart';

class CartProvider extends ChangeNotifier {
  var productCollection = FirebaseFirestore.instance.collection('products');
  var cartCollection = FirebaseFirestore.instance.collection('cart');

  Future<void> checkout() async {
    try {
      ProductProvider productProvider =
          Provider.of<ProductProvider>(Get.context!, listen: false);

      for (Product product in cartItems) {
        DocumentReference productRef = productCollection.doc(product.id);
        await productRef.update({
          'stock': product.stock - product.quantity,
        });
      }

      // Update the product list after checkout
      await productProvider.getProducts();
      notifyListeners();

      await clearCart();
    } catch (error) {
      debugPrint('Error during checkout: $error');
    }
  }

  List<Product> cartItems = [];

  Future<void> fetchCartItems() async {
    try {
      QuerySnapshot cartSnapshot = await cartCollection.get();
      List<Product> updatedCartItems = cartSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      cartItems = updatedCartItems;
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching cart items: $error');
    }
  }

  Future<void> addToCart(String productId) async {
    try {
      // Get the product data from Firebase Firestore
      DocumentSnapshot productSnapshot =
          await productCollection.doc(productId).get();

      if (productSnapshot.exists) {
        Product product =
            Product.fromJson(productSnapshot.data() as Map<String, dynamic>);

        if (product.stock > 0) {
          int existingProductIndex =
              cartItems.indexWhere((item) => item.id == productId);

          if (existingProductIndex != -1) {
            cartItems[existingProductIndex].quantity += 1;
            cartItems[existingProductIndex].sellingPrice =
                product.sellingPrice * cartItems[existingProductIndex].quantity;

            await cartCollection.doc(productId).update({
              'quantity': cartItems[existingProductIndex].quantity,
              'sellingPrice': cartItems[existingProductIndex].sellingPrice,
            });
          } else {
            cartItems.add(product);
            await cartCollection.doc(productId).set({
              ...product.toJson(),
              'quantity': 1,
            });
          }

          QuerySnapshot cartSnapshot = await cartCollection.get();
          cartItems = cartSnapshot.docs
              .map(
                  (doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          notifyListeners();
        } else {
          debugPrint('Product stock is 0');
        }
      } else {
        debugPrint('Product not found');
      }
    } catch (error) {
      debugPrint('Error adding product to cart: $error');
    }
  }

  Future<void> decrementFromCart(String productId) async {
    try {
      int existingProductIndex =
          cartItems.indexWhere((item) => item.id == productId);

      var productSnapshot = await productCollection.doc(productId).get();
      Product product =
          Product.fromJson(productSnapshot.data() as Map<String, dynamic>);
      if (existingProductIndex != -1) {
        if (cartItems[existingProductIndex].quantity == 1) {
          // Jika kuantitas sebelumnya adalah 1, hapus produk dari keranjang
          await cartCollection.doc(productId).delete();
          cartItems.removeAt(existingProductIndex);
        } else {
          // Kurangi kuantitas dan perbarui harga jual
          cartItems[existingProductIndex].quantity -= 1;
          cartItems[existingProductIndex].sellingPrice =
              product.sellingPrice * cartItems[existingProductIndex].quantity;

          await cartCollection.doc(productId).update({
            'quantity': cartItems[existingProductIndex].quantity,
            'sellingPrice': cartItems[existingProductIndex].sellingPrice,
          });
        }

        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error decrementing product from cart: $error');
    }
  }

  double getSubtotal() {
    double subtotal = 0;
    for (Product product in cartItems) {
      subtotal += product.sellingPrice;
    }
    return subtotal;
  }

  double getTotalPrice() {
    double subtotal = getSubtotal();
    double discount = subtotal * 0; // Diskon 0%
    double tax = subtotal * 0.1; // Pajak 10%
    double totalPrice = subtotal - discount + tax;
    return totalPrice;
  }

  int getQuantityInCart(String productId) {
    int quantity = 0;
    for (Product product in cartItems) {
      if (product.id == productId) {
        quantity = product.quantity;

        break;
      }
    }
    return quantity;
  }

  double getTotalProfit() {
    double totalProfit = 0;
    for (Product product in cartItems) {
      int profitPerItem =
          (product.sellingPrice - product.basicPrice) * product.quantity;
      totalProfit += profitPerItem;
    }
    return totalProfit;
  }

  Future<void> clearCart() async {
    try {
      cartItems.clear();
      notifyListeners();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      QuerySnapshot cartSnapshot = await cartCollection.get();
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (error) {
      debugPrint('Error clearing cart: $error');
    }
  }
}
