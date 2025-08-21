import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetUsers extends StatelessWidget {
  const WidgetUsers({
    super.key,
    required this.data,
    required this.title,
    required this.type,
  });

  final Map<String, dynamic> data;
  final String title;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            '${data[type]}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
