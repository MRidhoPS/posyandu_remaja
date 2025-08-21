import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataContainer extends StatelessWidget {
  const DataContainer({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.data,
    required this.type,
    required this.satuan,
  });

  final double height;
  final double width;
  final String title;
  final Map<String, dynamic> data;
  final String type;
  final String satuan;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      height: MediaQuery.of(context).size.height * height,
      width: MediaQuery.of(context).size.height * width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(2, 4),
                spreadRadius: 2)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                color: Colors.black38,
                fontWeight: FontWeight.w600,
                fontSize: 17),
          ),
          title != 'Bmi'
              ? Text(
                  '${data[type]} $satuan',
                  style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                )
              : Text(
                  '${data[type]}',
                  style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                ),
        ],
      ),
    );
  }
}
