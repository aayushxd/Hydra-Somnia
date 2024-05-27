import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/core/asset_path.dart';
import 'package:healthapp/features/bmi_calc/view/bmi_calc_screen.dart';
import 'package:flutter/services.dart';

import '../../features/homescreen/view/home_screen.dart';
import '../../features/profile/view/profile_screen.dart';

class CustomDrawer extends StatefulWidget {
  static const routeName = 'drawer';

  const CustomDrawer({super.key});
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpened = false;
  int screen = 0;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    changeStatusBar(false);
  }

  void changeStatusBar(bool isOpened) {
    if (isOpened) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  void open() {
    changeStatusBar(true);
    _animationController.forward();
    setState(() {
      _isDrawerOpened = true;
    });
  }

  void close() async {
    await _animationController.reverse();
    changeStatusBar(false);
    setState(() {
      _isDrawerOpened = false;
    });
  }

  void selectItem(int index) {
    if (index != screen) {
      setState(() {
        screen = index;
      });
    }
    close();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      ///TODO: Add screens here

      HomeScreen(
        openDrawer: open,
      ),
      BMICalcScreen(
        openDrawer: open,
      ),
      ProfileScreen(
        openDrawer: open,
      )
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 11, 33),
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 35),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(AssetPaths.displayPic),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: GoogleFonts.poppins(
                                  color: Colors.white54, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text("Shrijal Shrestha".split(' ')[0],
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500))
                          ],
                        )
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white60,
                        size: 20,
                      ),
                      onPressed: close,
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 40),
                  children: [
                    MenuItem(
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () {
                        selectItem(0);
                      },
                    ),
                    MenuItem(
                      icon: Icons.show_chart,
                      title: 'Statistics',
                      onTap: () {
                        selectItem(1);
                      },
                    ),
                    MenuItem(
                      icon: Icons.account_circle,
                      title: 'Profile',
                      onTap: () {
                        selectItem(2);
                      },
                    ),
                    MenuItem(
                      icon: Icons.exit_to_app,
                      title: 'Log Out',
                      onTap: () {
                        ///TODO: Add log out function here
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..scale(1.0 - (0.2 * _animationController.value))
                  ..translate(
                      0.0, size.height * 0.80 * _animationController.value, 0.0)
                  ..setEntry(3, 2, 0.002)
                  ..rotateX(0.15 * _animationController.value),
                origin: const Offset(0, 0),
                alignment: Alignment.center,

                // comment the child and uncomment the commented child to get the curved app drawer
                child: child,
                // child: ClipRRect(
                //   borderRadius: BorderRadius.circular(20*_animationController.value),
                //   child: AbsorbPointer(
                //     absorbing: _isDrawerOpened,
                //     child: screens[screen],
                //   ),
                // )
              );
            },
            child: AbsorbPointer(
              absorbing: _isDrawerOpened,
              child: screens[screen],
            ))
      ]),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Function()? onTap;
  const MenuItem({super.key, this.icon, this.title, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 35),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 21,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              title ?? "",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
