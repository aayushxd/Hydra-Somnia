import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/features/homescreen/provider/home_provider.dart';

// providers

class DailyAmountDial extends StatelessWidget {
  const DailyAmountDial(
      {super.key, required this.leftAmount, required this.percent});
  final double percent;
  final int leftAmount;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: -pi / 2,
          child: SizedBox(
            width: 170,
            height: 170,
            child: CustomPaint(
              painter: DialPainter(1),

              ///TODO: put target amount yesma
            ),
          ),
        ),

        ///TODO: put left amount below. aaile lai 10 rakheko chu
        leftAmount <= 0
            ? Text('Goal Reached',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ))
            : RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: leftAmount < 1000
                          ? '$leftAmount mL'
                          : '${(leftAmount / 1000).toStringAsFixed(1)} L',
                      style: GoogleFonts.poppins(
                          fontSize: 30, fontWeight: FontWeight.w600)),
                  const TextSpan(text: '\n'),
                  TextSpan(
                      text: 'left to drink',
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w300)),
                ]),
              )
      ],
    );
  }
}

class DialPainter extends CustomPainter {
  double percent;
  DialPainter(this.percent);
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.height / 2, size.width / 2);
    double fullRadius = (size.height / 2);
    Paint circle = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    Paint arc = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), fullRadius - 2, circle);
    canvas.drawArc(Rect.fromCircle(center: center, radius: fullRadius - 2), 0,
        2 * pi * percent, false, arc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
