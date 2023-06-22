import 'package:flutter/material.dart';

import '../model/product_model.dart';

class Transaction {
  final List<Product> products;
  final double profit;
  final DateTime timestamp;

  Transaction(
      {required this.products, required this.profit, required this.timestamp});
}

class TransactionProvider with ChangeNotifier {
  List<Transaction> transactionHistory = [];
  double dailyProfit = 0;
  double weeklyProfit = 0;
  double monthlyProfit = 0;
  double yearlyProfit = 0;

  void addTransaction(List<Product> products, double profit) {
    transactionHistory.add(Transaction(
      products: products,
      profit: profit,
      timestamp: DateTime.now(),
    ));

    calculateDailyProfit();
    calculateWeeklyProfit();
    calculateMonthlyProfit();
    calculateYearlyProfit();

    notifyListeners();
  }

  void calculateDailyProfit() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    dailyProfit = 0;
    for (Transaction transaction in transactionHistory) {
      if (transaction.timestamp.isAfter(today)) {
        dailyProfit += transaction.profit;
      }
    }
  }

  void calculateWeeklyProfit() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    weeklyProfit = 0;
    for (Transaction transaction in transactionHistory) {
      if (transaction.timestamp.isAfter(startOfWeek)) {
        weeklyProfit += transaction.profit;
      }
    }
  }

  void calculateMonthlyProfit() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    monthlyProfit = 0;
    for (Transaction transaction in transactionHistory) {
      if (transaction.timestamp.isAfter(startOfMonth)) {
        monthlyProfit += transaction.profit;
      }
    }
  }

  void calculateYearlyProfit() {
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);

    yearlyProfit = 0;
    for (Transaction transaction in transactionHistory) {
      if (transaction.timestamp.isAfter(startOfYear)) {
        yearlyProfit += transaction.profit;
      }
    }
  }
}
