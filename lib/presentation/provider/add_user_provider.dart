import 'package:flutter/material.dart';
import 'package:posrem_webapp/data/datasources/firebase_database.dart';

class AddUserProvider with ChangeNotifier {
  final DatabaseServices databaseServices = DatabaseServices();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String selectedGender = 'Pria';

  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final bornController = TextEditingController();
  final religionController = TextEditingController();
  final addressController = TextEditingController();
  final educationController = TextEditingController();
  final phoneNumController = TextEditingController();

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  Future<void> addUser() async {
  _isLoading = true;
  notifyListeners();

  try {
    await databaseServices.createUser(
      nameController.text,
      selectedGender,
      bornController.text,
      religionController.text,
      addressController.text,
      educationController.text,
      phoneNumController.text,
    );
  } catch (e) {
    print(e);
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    genderController.dispose();
    bornController.dispose();
    religionController.dispose();
    addressController.dispose();
    educationController.dispose();
    phoneNumController.dispose();
  }
}
