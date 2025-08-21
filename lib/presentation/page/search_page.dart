import 'package:flutter/material.dart';
import 'package:posrem_webapp/data/datasources/firebase_database.dart';

class PatientSearchPage extends StatefulWidget {
  @override
  _PatientSearchPageState createState() => _PatientSearchPageState();
}

class _PatientSearchPageState extends State<PatientSearchPage> {
  Map<String, dynamic>? patientData;
  final nameController = TextEditingController();
  String selectedGender = 'Laki-laki'; // Default gender

  Future<void> fetchPatientData() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text("Nama harus diisi!")),
      );
      return;
    }

    final data = await DatabaseServices()
        .searchPatientByNameAndGender(name, selectedGender);
    setState(() {
      patientData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cari Data Pasien"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Nama
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
            ),
            const SizedBox(height: 16),
            // Dropdown Gender
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(labelText: "Pilih Gender"),
              items: ['Laki-laki', 'Perempuan']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            // Tombol Cari
            ElevatedButton(
              onPressed: fetchPatientData,
              child: const Text("Cari Data"),
            ),
            const SizedBox(height: 16),
            // Tampilan Data Pasien
            Expanded(
              child: patientData == null
                  ? const Center(child: Text("Masukkan data untuk mencari pasien"))
                  : buildPatientProgress(patientData!),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan data perkembangan pasien
  Widget buildPatientProgress(Map<String, dynamic> patientData) {
    final healthData = patientData['data'] as Map<String, dynamic>;

    return ListView(
      children: healthData.entries.map((entry) {
        final data = entry.value as Map<String, dynamic>;
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text("Tanggal: ${data['tanggal_pencatatan']}"),
            subtitle: Text(
              "Tinggi Badan: ${data['tb']} cm\n"
              "Berat Badan: ${data['bb']} kg\n"
              "BMI: ${data['bmi']} (${data['ket_bmi']})",
            ),
          ),
        );
      }).toList(),
    );
  }
}
