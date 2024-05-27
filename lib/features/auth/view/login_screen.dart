import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthapp/core/const/app_constants.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';
import 'package:healthapp/core/styles/app_color.dart';
import 'package:healthapp/features/auth/provider/auth_provider.dart';
import 'package:healthapp/features/data_entry/view/data_entry_screen.dart';
import 'package:healthapp/features/homescreen/view/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppConstants.appLogo,
                      height: 180,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Text(
                        AppConstants.appName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.abrilFatface(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: double.maxFinite),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Text(
                      'This app keeps track your daily water intake and reminds you to drink water by sending notification in intervals and keeps your sleep record.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white.withOpacity(0.60))),
                ),
                // Row(
                //   children: [
                //     ElevatedButton(
                //       child: const Text("test"),
                //       onPressed: () async {
                //         final u = await UserTable().select().toList();
                //         for (var element in u) {
                //           print(element.toJson());
                //         }
                //       },
                //     ),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     ElevatedButton(
                //       child: const Text("clear db"),
                //       onPressed: () async {
                //         final u = await UserTable().select().delete();
                //       },
                //     ),
                //   ],
                // ),
                GestureDetector(
                  onTap: () async {
                    final AuthController auth = Get.put(AuthController());
                    auth.signInWithGoogle().then((User? user) async {
                      if (user != null) {
                        final l = await UserTable().select().toList();
                        print(l.length);
                        for (var i in l) {
                          print(i);
                        }
                        final u = await UserTable()
                            .select()
                            .uid
                            .equals(user.uid)
                            .toSingle();
                        print(u);
                        if (u == null) {
                          UserTable userModel = UserTable();
                          userModel.email = user.email;
                          userModel.name = user.displayName;
                          userModel.photoUrl = user.photoURL;
                          userModel.uid = user.uid;
                          print(user.uid);
                          Get.to(DataEntryScreen(
                            userModel: userModel,
                          ));
                        } else {
                          Get.to(() => const HomeScreen());
                        }
                      } else {
                        // Get.showSnackbar(const GetSnackBar(
                        //   backgroundColor: Colors.red,
                        //   messageText: Text(
                        //     "Something went wrong. Try again.",
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // ));
                      }
                    });
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.blueGrey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Image.asset(
                                'assets/icons/google.png',
                                height: 20,
                              )),
                          Text(
                            'Continue with Google',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 11),
                          children: [
                            const TextSpan(
                              text: 'By signing up you accept the ',
                            ),
                            TextSpan(
                                text: 'Terms of Service and Privacy Policy.',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500))
                          ]),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
