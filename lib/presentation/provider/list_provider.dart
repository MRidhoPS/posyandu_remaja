import 'package:flutter/material.dart';
import 'package:posrem_webapp/data/datasources/firebase_database.dart';

class ListProvider extends ChangeNotifier{
  final DatabaseServices _databaseServices = DatabaseServices();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ListProvider(){
    fethAllUser();
  }

  Future<void> searchUser(String query) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners(); // langsung update UI ke state "loading"

      final results = await _databaseServices.searchUser(query);

      _users = results;
    } catch (e) {
      _error = e.toString();
      _users = []; // pastikan reset biar tidak stuck
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fethAllUser() async{
    _isLoading = true;
    notifyListeners();

    try {
      _users = await _databaseServices.fetchAllUser();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _users = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}