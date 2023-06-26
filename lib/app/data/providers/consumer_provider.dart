import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/consumer_model.dart';

class ConsumersProvider extends ChangeNotifier {
  final _consumersCollection =
      FirebaseFirestore.instance.collection('consumers');

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final List<ConsumersModel> _listConsumers = [];
  List<ConsumersModel> get listConsumers => _listConsumers;
  String _duplicateConsumersName = '';
  String get duplicateConsumersName => _duplicateConsumersName;
  String _errorName = '';
  String get errorName => _errorName;

  String _errorAddress = '';
  String get errorAddress => _errorAddress;

  String _errorPhoneNumber = '';
  String get errorPhoneNumber => _errorPhoneNumber;
  void validate() {
    _errorName = _validateField(nameController, 'Name');
    _errorAddress = _validateField(addressController, 'Address');
    _errorPhoneNumber = _validateField(phoneNumberController, 'Phone Number');
    notifyListeners();
  }

  String _validateField(TextEditingController controller, String fieldName) {
    final String value = controller.text.trim();
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return '';
  }

  void resetFields() {
    _errorName = '';
    _errorAddress = '';
    _errorPhoneNumber = '';
    _duplicateConsumersName = '';
    nameController.clear();
    addressController.clear();
    phoneNumberController.clear();
    notifyListeners();
  }

  Future<void> addConsumer() async {
    validate();
    final name = nameController.text;
    final address = addressController.text;
    final phoneNumber = phoneNumberController.text;

    if (_errorName.isNotEmpty ||
        _errorAddress.isNotEmpty ||
        _errorPhoneNumber.isNotEmpty) {
      notifyListeners();
      return;
    }

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

      ConsumersModel newConsumers = ConsumersModel(
        id: newId,
        name: name,
        address: address,
        phoneNumber: phoneNumber,
      );
      final QuerySnapshot duplicateSnapshot = await _consumersCollection
          .doc(userEmail)
          .collection('list consumers')
          .where('name', isEqualTo: newConsumers.name)
          .limit(1)
          .get();

      if (duplicateSnapshot.docs.isNotEmpty) {
        _duplicateConsumersName = "${newConsumers.name} is allready exist";
        notifyListeners();
        return;
      }
      await _consumersCollection
          .doc(userEmail)
          .collection('list consumers')
          .doc(newId)
          .set({
        'id': newId,
        'name': name,
        'address': address,
        'phoneNumber': phoneNumber,
      });
      _listConsumers.add(newConsumers);

      resetFields();
      notifyListeners();
      Get.back();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> getConsumers() async {
    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;
      final QuerySnapshot snapshot = await _consumersCollection
          .doc(userEmail)
          .collection('list consumers')
          .get();

      _listConsumers.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final consumer = ConsumersModel(
          id: data['id'].toString(),
          name: data['name'].toString(),
          address: data['address'].toString(),
          phoneNumber: data['phoneNumber'].toString(),
        );
        _listConsumers.add(consumer);
      }

      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteConsumer(String consumerId) async {
    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;

      await _consumersCollection
          .doc(userEmail)
          .collection('list consumers')
          .doc(consumerId)
          .delete();

      _listConsumers.removeWhere((c) => c.id == consumerId);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
