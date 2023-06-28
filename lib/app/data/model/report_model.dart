import 'package:cloud_firestore/cloud_firestore.dart';

import 'product_model.dart';

class ReportModel {
  final int? id;
  final List<Product> products;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final double profit;
  final DateTime timestamp;

  ReportModel({
    required this.id,
    required this.products,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.profit,
    required this.timestamp,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> productData = json['products'];
    final List<Product> products = productData
        .map((productJson) => Product.fromJson(productJson))
        .toList();

    return ReportModel(
      id: json['id'] as int?,
      products: products,
      subtotal: json['subtotal'] as double,
      tax: json['tax'] as double,
      discount: json['discount'] as double,
      total: json['total'] as double,
      profit: json['profit'] as double,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((product) => product.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'total': total,
      'profit': profit,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
