import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/consumer_model.dart';

class CustomersProvider extends ChangeNotifier {
  final _consumersCollection =
      FirebaseFirestore.instance.collection('consumers');

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final List<ConsumersModel> _listConsumers = [];
  List<ConsumersModel> get listConsumers => _listConsumers;

  Future<void> addConsumer() async {
    nameController.clear();
    addressController.clear();
    phoneNumberController.clear();
    final name = nameController.text;
    final address = addressController.text;
    final phoneNumber = phoneNumberController.text;

    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;
      final QuerySnapshot snapshot = await _consumersCollection
          .doc(userEmail)
          .collection('list consumers')
          .get();

      final categoryDocs = snapshot.docs;

      int maxId = 0;
      for (var doc in categoryDocs) {
        final id = int.tryParse(
            (doc.data() as Map<String, dynamic>)['id']?.toString() ?? '');
        if (id != null && id > maxId) {
          maxId = id;
        }
      }
      final newId = (maxId + 1).toString();
      await _consumersCollection
          .doc(userEmail)
          .collection('list consumers')
          .add({
        'id': newId,
        'name': name,
        'address': address,
        'phoneNumber': phoneNumber,
      });

      final newConsumers = ConsumersModel(
        id: newId,
        name: name,
        address: address,
        phoneNumber: phoneNumber,
      );
      _listConsumers.add(newConsumers);

      nameController.clear();
      addressController.clear();
      phoneNumberController.clear();

      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
