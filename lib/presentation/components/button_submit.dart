// import 'package:flutter/material.dart';
// import 'package:posrem_webapp/database/firebase_database.dart';

// Row buttonSubmit(
//     TextEditingController nameController,
//     TextEditingController maritalController,
//     TextEditingController bmiController,
//     TextEditingController bmiDescController,
//     TextEditingController idController) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Center(
//         child: ElevatedButton(
//           onPressed: () {
//             try {
//               DatabaseServices().createUser(
//                 nameController.text,
//                 maritalController.text,
//               );

//               nameController.clear();
//               maritalController.clear();
//             } catch (e) {
//               AlertDialog(title: Text(e.toString()));
//             }
//           },
//           child: const Text("Add User"),
//         ),
//       ),
//       Center(
//         child: ElevatedButton(
//           onPressed: () {
//             try {
//               DatabaseServices().addMonthlyData(
//                 bmiController.text,
//                 bmiDescController.text,
//                 idController.text,
//               );

//               bmiController.clear();
//               bmiDescController.clear();
//               idController.clear();
//             } catch (e) {
//               AlertDialog(title: Text(e.toString()));
//             }
//           },
//           child: const Text("Monthly Updated"),
//         ),
//       ),
//     ],
//   );
// }
