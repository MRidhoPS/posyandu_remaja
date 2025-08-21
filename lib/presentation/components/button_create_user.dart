import 'package:flutter/material.dart';
import 'package:posrem_webapp/data/controller/input_controller.dart';
import 'package:posrem_webapp/data/datasources/firebase_database.dart';
import 'package:posrem_webapp/presentation/page/home_user.dart';
import 'package:posrem_webapp/presentation/provider/list_provider.dart';
import 'package:provider/provider.dart';

ElevatedButton submitMonthlyData(BuildContext context, id) {
  return ElevatedButton(
    onPressed: () {
      try {
        DatabaseServices().addMonthlyData(
          id,
          tbController.text,
          bbController.text,
          tdController.text,
          lilaController.text,
          lpController.text,
        );

        context.read<ListProvider>().fethAllUser();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));

        tbController.clear();
        bbController.clear();
        tdController.clear();
        lilaController.clear();
        lpController.clear();
        bmiController.clear();
        bmiDescController.clear();
        dateController.clear();
      } catch (e) {
        AlertDialog(title: Text(e.toString()));
      }
    },
    child: const Text("Monthly Updated"),
  );
}
