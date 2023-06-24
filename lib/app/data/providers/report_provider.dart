import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

class ReportModel {
  final int? id;
  final List<Product> products;
  final double profit;
  final DateTime timestamp;

  ReportModel({
    required this.id,
    required this.products,
    required this.profit,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
      'profit': profit,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class ReportProvider with ChangeNotifier {
  final _reportCollection = FirebaseFirestore.instance.collection('reports');
  List<ReportModel> transactionHistory = [];
  double dailyProfit = 0;
  double weeklyProfit = 0;
  double monthlyProfit = 0;
  double yearlyProfit = 0;

  Future<void> addTransaction(List<Product> products, double profit) async {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    final QuerySnapshot snapshot =
        await _reportCollection.doc(userEmail).collection('list reports').get();

    final categoryDocs = snapshot.docs;

    int maxId = 0;
    for (var doc in categoryDocs) {
      final id = int.tryParse(
          (doc.data() as Map<String, dynamic>)['id']?.toString() ?? '');
      if (id != null && id > maxId) {
        maxId = id;
      }
    }

    final newId = (maxId + 1);

    final DocumentReference documentReference = _reportCollection
        .doc(userEmail)
        .collection('list transaction')
        .doc("$newId");
    await documentReference.set(
      ReportModel(
        id: newId,
        products: products,
        profit: profit,
        timestamp: DateTime.now(),
      ).toJson(),
    );

    transactionHistory.add(ReportModel(
      id: newId,
      products: products,
      profit: profit,
      timestamp: DateTime.now(),
    ));
    calculateDailyProfit();
    calculateWeeklyProfit();
    calculateMonthlyProfit();
    calculateYearlyProfit();
    debugPrint("$dailyProfit");

    notifyListeners();
  }

  double calculateProfit(List<Product> products) {
    double totalProfit = 0;
    for (Product product in products) {
      double profitPerItem = ((product.sellingPrice - product.basicPrice) *
          product.quantity) as double;
      totalProfit += profitPerItem;
    }
    return totalProfit;
  }

  void calculateDailyProfit() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    dailyProfit = 0;
    for (ReportModel transaction in transactionHistory) {
      if (transaction.timestamp.isAfter(today)) {
        dailyProfit += transaction.profit;
      }
    }
  }

  void calculateWeeklyProfit() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    weeklyProfit = 0;
    for (ReportModel transaction in transactionHistory) {
      if (transaction.timestamp.isAfter(startOfWeek)) {
        weeklyProfit += transaction.profit;
      }
    }
  }

  void calculateMonthlyProfit() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    monthlyProfit = 0;
    for (ReportModel transaction in transactionHistory) {
      if (transaction.timestamp.isAfter(startOfMonth)) {
        monthlyProfit += transaction.profit;
      }
    }
  }

  void calculateYearlyProfit() {
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);

    yearlyProfit = 0;
    for (ReportModel transaction in transactionHistory) {
      if (transaction.timestamp.isAfter(startOfYear)) {
        yearlyProfit += transaction.profit;
      }
    }
  }
}
