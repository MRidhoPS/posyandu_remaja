import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:posrem_webapp/data/datasources/firebase_database.dart';

class ReportData extends StatefulWidget {
  const ReportData({super.key});

  @override
  State<ReportData> createState() => _ReportDataState();
}

class _ReportDataState extends State<ReportData> {
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Data"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: monthController,
                decoration: const InputDecoration(
                  label: Text('Month'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: yearController,
                decoration: const InputDecoration(
                  label: Text('Year'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (monthController.text.isNotEmpty &&
                      yearController.text.isNotEmpty) {
                    DatabaseServices().exportReportToExcel(
                      context: context,
                      monthName: monthController.text,
                      year: int.parse(yearController.text),
                    );

                    monthController.clear();
                    yearController.clear();
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      title: "Input Kosong",
                      desc: "Harap isi bulan dan tahun terlebih dahulu.",
                      btnOkOnPress: () {},
                    ).show();
                  }
                },
                child: const Text("Report Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
