import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posrem_webapp/data/datasources/firebase_database.dart';

class DetailuserProvider  extends ChangeNotifier{
  Map<String, dynamic>? usersDetails;
  List<String> availableYears = [];
  Map<String, Map<String, dynamic>> weightDataByMonth =
      {}; // Data berat badan per bulan
  bool isLoading = false;

  Future<void> fetchDetailUser(String userId) async{
    isLoading = true;
    notifyListeners();

    try {
      usersDetails = await DatabaseServices().fetchUserById(userId);
      availableYears = usersDetails?['data']?.keys.toList().cast<String>() ?? [];
    } catch (e) {
      debugPrint("Error fetching user details: $e");
      usersDetails = null;
      availableYears = [];
    } finally {
      isLoading = false;
      notifyListeners(); 
    }
  }

  /// Fetch data bulanan untuk chart berat badan
  Future<void> fetchMonthlyWeightData(String userId, String year) async {
    isLoading = true;
    notifyListeners();

    try {
      weightDataByMonth.clear();
      final data = usersDetails?['data'][year] ?? {};

      for (var entry in data.entries) {
        var entryData = entry.value;
        Timestamp createdAt = entryData['createdAt'];
        String monthKey = DateFormat('MM')
            .format(createdAt.toDate()); // Simpan bulan dalam angka (01-12)
        String monthName =
            DateFormat('MMMM').format(createdAt.toDate()); // Simpan nama bulan

        if (entryData.containsKey('bb')) {
          double weight = double.tryParse(entryData['bb'].toString()) ?? 0.0;

          // Simpan hanya data terbaru dalam bulan itu
          if (!weightDataByMonth.containsKey(monthKey) ||
              createdAt.millisecondsSinceEpoch >
                  weightDataByMonth[monthKey]!['createdAt']
                      .millisecondsSinceEpoch) {
            weightDataByMonth[monthKey] = {
              'monthName': monthName,
              'weight': weight,
              'createdAt': createdAt,
              'bmi': entryData['bmi']
            };
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching monthly weight data: $e");
      weightDataByMonth = {};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}