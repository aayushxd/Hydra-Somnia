import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/core/styles/app_color.dart';
import 'package:healthapp/core/styles/app_string.dart';

class CustomAppBar extends StatelessWidget {
  final Function()? openDrawer;
  final Widget? trailing;
  const CustomAppBar({super.key, this.openDrawer, this.trailing});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // MenuButton(openDrawer),
          Image.asset(
            'assets/icons/logo.png',
            height: 20,
          ),
          const SizedBox(
            width: 12,
          ),
          //Text('Drinkable',style:  GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 17),)
          FittedBox(
            child: Text(
              AppStrings.appTitle,
              style: GoogleFonts.abrilFatface(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: AppColors.primaryColor),
            ),
          ),
          // trailing ??
          //     const CircleAvatar(
          //       radius: 19,
          //       backgroundColor: Colors.transparent,
          //     )
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final Function()? onTap;
  const MenuButton(this.onTap, {super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.1,
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 11,
              height: 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              width: 16,
              height: 2,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(2)),
            ),
          ],
        ),
      ),
    );
  }
}
