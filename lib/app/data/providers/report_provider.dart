import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../model/report_model.dart';

class ReportProvider with ChangeNotifier {
  final _reportCollection = FirebaseFirestore.instance.collection('reports');
  final _chartCollection = FirebaseFirestore.instance.collection('charts');

  List<ReportModel> transactionHistory = [];
  double dailyProfit = 0;
  double weeklyProfit = 0;
  double monthlyProfit = 0;
  double yearlyProfit = 0;

  Future<void> saveMonthlyChartToFirebase() async {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    final List<double> monthlyProfits = List<double>.generate(
        12, (index) => getMonthlyProfitByIndex(index + 1));

    final DocumentReference chartDoc =
        _chartCollection.doc(userEmail).collection('chart_data').doc('monthly');

    await chartDoc.set({'monthly_profits': monthlyProfits});
  }

  Future<List<double>> getMonthlyChartFromFirebase() async {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    final DocumentSnapshot chartSnapshot = await _chartCollection
        .doc(userEmail)
        .collection('chart_data')
        .doc('monthly')
        .get();

    final data = chartSnapshot.data() as Map<String, dynamic>;
    final List<double> monthlyProfits =
        List<double>.from(data['monthly_profits']);

    return monthlyProfits;
  }

  Future<void> addTransaction(List<Product> products, double profit) async {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    final QuerySnapshot snapshot =
        await _reportCollection.doc(userEmail).collection('list reports').get();

    final reportsDocs = snapshot.docs;

    int maxId = 0;
    for (var doc in reportsDocs) {
      final id = int.tryParse(
          (doc.data() as Map<String, dynamic>)['id']?.toString() ?? '');
      if (id != null && id > maxId) {
        maxId = id;
      }
    }

    var newId = (maxId + 1);
    while (transactionHistory.any((transaction) => transaction.id == newId)) {
      newId++;
    }

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
    await saveMonthlyChartToFirebase();
    debugPrint("$dailyProfit");

    notifyListeners();
  }

  Future<void> getTransactionHistory() async {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    final QuerySnapshot snapshot = await _reportCollection
        .doc(userEmail)
        .collection('list transaction')
        .get();

    transactionHistory = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ReportModel.fromJson(data);
    }).toList();

    calculateDailyProfit();
    calculateWeeklyProfit();
    calculateMonthlyProfit();
    calculateYearlyProfit();

    notifyListeners();
  }

  double getWeeklyProfitByIndex(int index) {
    if (index < 0 || index >= transactionHistory.length) {
      return 0.0;
    }

    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    List<ReportModel> weeklyTransactions = transactionHistory
        .where((transaction) =>
            transaction.timestamp.isAfter(startOfWeek) &&
            transaction.timestamp.isBefore(endOfWeek))
        .toList();

    double weeklyProfit = weeklyTransactions.fold(0.0,
        (previousValue, transaction) => previousValue + transaction.profit);

    return weeklyProfit;
  }

  double calculateProfit(List<Product> products) {
    double totalProfit = 0;
    for (Product product in products) {
      double profitPerItem = ((product.sellingPrice - product.basicPrice) *
          product.quantity) as double;
      totalProfit += profitPerItem;
    }
    notifyListeners();
    return totalProfit;
  }

  void calculateDailyProfit() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    dailyProfit = transactionHistory
        .where((transaction) => transaction.timestamp.isAfter(today))
        .fold(0,
            (previousValue, transaction) => previousValue + transaction.profit);
    notifyListeners();
  }

  void calculateWeeklyProfit() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    weeklyProfit = transactionHistory
        .where((transaction) => transaction.timestamp.isAfter(startOfWeek))
        .fold(0,
            (previousValue, transaction) => previousValue + transaction.profit);

    notifyListeners();
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

  double getMonthlyProfitByIndex(int index) {
    if (index < 1 || index > 12) {
      return 0;
    }
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, index, 1);
    DateTime endOfMonth = DateTime(now.year, index + 1, 0);

    double monthlyProfit = transactionHistory
        .where((transaction) =>
            transaction.timestamp.isAfter(startOfMonth) &&
            transaction.timestamp.isBefore(endOfMonth))
        .fold(0,
            (previousValue, transaction) => previousValue + transaction.profit);

    return monthlyProfit;
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

  double getYearlyProfit() {
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime endOfYear = DateTime(now.year, 12, 31);

    double yearlyProfit = transactionHistory
        .where((transaction) =>
            transaction.timestamp.isAfter(startOfYear) &&
            transaction.timestamp.isBefore(endOfYear))
        .fold(0,
            (previousValue, transaction) => previousValue + transaction.profit);

    return yearlyProfit;
  }
}
