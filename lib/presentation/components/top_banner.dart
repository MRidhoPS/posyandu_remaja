import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBanner extends StatelessWidget {
  const TopBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
            blurStyle: BlurStyle.normal,
            offset: Offset(2, 3)
          )
        ]
      ),
      child: Text(
        textAlign: TextAlign.start,
        "Welcome Kader\nPosrem",
        style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: 1),
      ),
    );
  }
}
