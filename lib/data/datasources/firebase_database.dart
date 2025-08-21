import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class DatabaseServices {
  final db = FirebaseFirestore.instance;

  void createUser(
    String name,
    String gender,
    String born,
    String religion,
    String address,
    String education,
    String phoneNum,
  ) async {
    final userDocRef = db.collection('users').doc();

    // Create user document with initial values and null data
    final userData = {
      'name': name,
      'gender': gender,
      'born': born,
      'religion': religion,
      'address': address,
      'education': education,
      'phoneNum': phoneNum,
      'data': null, // Initialize data as null
    };

    await userDocRef
        .set(userData)
        .onError((e, _) => print("Error creating user document: $e"));
  }

  Future<List<Map<String, dynamic>>> searchUser(String query) async {
    final db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (query.isEmpty) {
      snapshot = await db.collection('users').get();
    } else {
      final lowerQuery = query.toLowerCase();

      snapshot = await db
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: lowerQuery)
          .where('name', isLessThan: lowerQuery + 'z')
          .get();
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; 
      return data;
    }).toList();
  }


  calculateBMI(dynamic bb, dynamic tb) {
    final bbDouble = double.tryParse(bb.toString()) ?? 0;
    final tbDouble = double.tryParse(tb.toString()) ?? 0;
    final tbConvert = tbDouble / 100;
    final tbQuad = tbConvert * tbConvert;

    final bmi = bbDouble / tbQuad;
    final bmiRest = bmi.toString().split('.')[0];

    return bmiRest;
  }

  statusBmi(dynamic bb, dynamic tb) {
    final bmi = double.tryParse(calculateBMI(bb, tb).toString()) ?? 0;
    if (bmi < 18) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Healthy';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  void addMonthlyData(
    String id,
    String tb,
    String bb,
    String td,
    String lila,
    String lp,
  ) async {
    final userDocRef = db.collection('users').doc(id);
    final year = DateTime.now().year.toString();
    final newEntryId = 'entry_${DateTime.now().millisecondsSinceEpoch}';

    final bmiRest = calculateBMI(bb, tb);
    final bmiStatus = statusBmi(bb, tb);

    try {
      await db.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userDocRef);

        if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> yearlyData = userData['data'] ?? {};

          // Ambil data untuk tahun ini atau inisialisasi baru
          Map<String, dynamic> currentYearData =
              yearlyData[year] as Map<String, dynamic>? ?? {};

          final newEntry = {
            'tb': tb,
            'bb': bb,
            'td': td,
            'lila': lila,
            'lp': lp,
            'bmi': bmiRest,
            'bmiDesc': bmiStatus,
            'createdAt': Timestamp.now(),
          };

          // Tambahkan data entry baru ke tahun saat ini
          currentYearData[newEntryId] = newEntry;

          // Update struktur data berdasarkan tahun
          yearlyData[year] = currentYearData;

          transaction.update(userDocRef, {
            'data': yearlyData,
          });
        } else {
          // Jika dokumen belum ada, buat struktur baru
          transaction.set(userDocRef, {
            'data': {
              year: {
                newEntryId: {
                  'tb': tb,
                  'bb': bb,
                  'td': td,
                  'lila': lila,
                  'lp': lp,
                  'bmi': bmiRest,
                  'bmiDesc': bmiStatus,
                  'createdAt': Timestamp.now(),
                },
              },
            },
          });
        }
      });
    } catch (e) {
      print('Error updating monthly data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllUser() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> jsonData = querySnapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
    }).toList();

    return jsonData;
  }

  Future<Map<String, dynamic>> fetchUserById(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
  }

  Future<Map<String, dynamic>?> searchPatientByNameAndGender(
      String name, String gender) async {
    try {
      // Query ke Firestore berdasarkan nama dan gender
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: name)
          .where('gender', isEqualTo: gender)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Ambil data pertama dari hasil query
        return querySnapshot.docs.first.data();
      } else {
        print("Data pasien tidak ditemukan!");
        return null;
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      return null;
    }
  }

  Future<void> exportReportToExcel({
    required BuildContext context,
    required String monthName,
    required int year,
  }) async {
    try {
      final Map<String, int> monthMap = {
        "January": 1,
        "February": 2,
        "March": 3,
        "April": 4,
        "May": 5,
        "June": 6,
        "July": 7,
        "August": 8,
        "September": 9,
        "October": 10,
        "November": 11,
        "December": 12,
      };

      final int? month = monthMap[monthName];
      if (month == null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          title: "Bulan tidak valid",
          desc: "Nama bulan tidak dikenali.",
          btnOkOnPress: () {},
        ).show();
        return;
      }

      final querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      final Map<String, List<Map<String, dynamic>>> result = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final userName = data['name'] ?? 'Unknown';
        final yearKey = year.toString();
        final userYearData = data['data']?[yearKey];

        if (userYearData != null && userYearData is Map) {
          final filteredEntries = <Map<String, dynamic>>[];

          userYearData.forEach((_, entryData) {
            final createdAt = entryData['createdAt'];
            if (createdAt != null && createdAt is Timestamp) {
              final entryDate = createdAt.toDate();
              if (entryDate.month == month) {
                filteredEntries.add({
                  'name': userName,
                  'lila': entryData['lila'],
                  'tb': entryData['tb'],
                  'bb': entryData['bb'],
                  'td': entryData['td'],
                  'bmi': entryData['bmi'],
                  'bmiDesc': entryData['bmiDesc'],
                  'lp': entryData['lp'],
                });
              }
            }
          });

          if (filteredEntries.isNotEmpty) {
            result[userName] = filteredEntries;
          }
        }
      }

      // Tampilkan dialog jika tidak ada data
      if (result.isEmpty) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          title: "Data Tidak Ditemukan",
          desc: "Tidak ada data pada bulan $monthName tahun $year.",
          btnOkOnPress: () {},
        ).show();
        return;
      }

      // Buat Excel
      final excel = Excel.createExcel();
      final Sheet sheet = excel['Laporan'];

      sheet.appendRow([
        TextCellValue("Nama"),
        TextCellValue("Lingkar Lengan Atas (lila)"),
        TextCellValue("Tinggi Badan (tb)"),
        TextCellValue("Berat Badan (bb)"),
        TextCellValue("Tekanan Darah (td)"),
        TextCellValue("BMI"),
        TextCellValue("Keterangan BMI"),
        TextCellValue("Lingkar Perut (lp)"),
      ]);

      for (var entries in result.values) {
        for (var entry in entries) {
          sheet.appendRow([
            TextCellValue(entry['name']?.toString() ?? ''),
            TextCellValue(entry['lila']?.toString() ?? ''),
            TextCellValue(entry['tb']?.toString() ?? ''),
            TextCellValue(entry['bb']?.toString() ?? ''),
            TextCellValue(entry['td']?.toString() ?? ''),
            TextCellValue(entry['bmi']?.toString() ?? ''),
            TextCellValue(entry['bmiDesc']?.toString() ?? ''),
            TextCellValue(entry['lp']?.toString() ?? ''),
          ]);
        }
      }

      // Encode ke bytes
      final fileBytes = excel.encode();

      // Download via browser (khusus web)
      final blob = html.Blob([fileBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "Laporan_$monthName$year.xlsx")
        ..click();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "Terjadi kesalahan saat meng-export data: $e",
        btnOkOnPress: () {},
      ).show();
    }
  }
}

Future<List<String>> fetchDataYear(String userId) async {
  final doc =
      await FirebaseFirestore.instance.collection('user').doc(userId).get();

  if (!doc.exists) {
    throw Exception('User not found');
  }

  // Ambil semua tahun yang tersedia dalam "data"
  Map<String, dynamic>? data = doc.data()?['data'];

  if (data != null) {
    return data.keys
        .toList(); // Mengembalikan daftar tahun (misal: ['2025', '2024'])
  }

  throw Exception('No year data found');
}

Future<Map<String, dynamic>> fetchDataMonthly(
    String userId, String year) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (!doc.exists) {
    throw Exception('User not found');
  }

  // Ambil data dari tahun yang dipilih
  Map<String, dynamic>? yearData = doc.data()?['data']?[year];

  if (yearData != null) {
    return yearData; // Mengembalikan semua entry bulanan dari tahun tersebut
  }

  throw Exception('No monthly data found for year $year');
}
