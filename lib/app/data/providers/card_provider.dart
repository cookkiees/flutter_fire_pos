import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

class CartProvider extends ChangeNotifier {
  var productCollection = FirebaseFirestore.instance.collection('products');
  var cartCollection = FirebaseFirestore.instance.collection('cart');
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
            .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        notifyListeners();
      } else {
        debugPrint('Product not found');
      }
    } catch (error) {
      debugPrint('Error adding product to cart: $error');
    }
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
}
