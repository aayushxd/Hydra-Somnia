import 'package:flutter/material.dart';

import '../../core/styles/app_color.dart';

class IconTitleNextRow extends StatelessWidget {
  final String icon;
  final String title;
  final String time;
  final VoidCallback onPressed;
  final Color color;
  final TextEditingController? controller;
  const IconTitleNextRow(
      {super.key,
      required this.icon,
      required this.title,
      required this.time,
      required this.onPressed,
      required this.color,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              child: Image.asset(
                icon,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 20,
                child: Center(
                  child: TextFormField(
                    controller: controller,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                    style: TextStyle(color: AppColors.gray, fontSize: 12),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: Text(
                time,
                textAlign: TextAlign.right,
                style: TextStyle(color: AppColors.gray, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 25,
              height: 25,
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/img/p_next.png",
                  width: 12,
                  height: 12,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
