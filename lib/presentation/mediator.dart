import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tiktik_v/presentation/chat_page.dart';

class MediatorPage extends StatefulWidget {
  const MediatorPage({super.key});

  @override
  State<MediatorPage> createState() => _MediatorPageState();
}

class _MediatorPageState extends State<MediatorPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      // Handle app lifecycle state changes if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xff181818),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Converse With",
          style: GoogleFonts.tomorrow(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hero.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
          child: _sectionOne(context),
        ),
      ),
    );
  }

  Widget _sectionOne(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height * 0.5,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF212121),
            border: Border.all(color: Colors.white, width: 0.5),

            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Text(
                "Welcome Sai",
                style: GoogleFonts.hankenGrotesk(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16), // Add space between sections
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Define action for the first container
              },
              child: _buildRoundedContainer(
                  height / 3, width / 1.9, Color(0xFF212121)),
            ),
            GestureDetector(
              onTap: () {
                // Define action for the second container
              },
              child: _buildRoundedContainer(
                height / 3,
                width / 5.1,
                Colors.transparent,
                Column(
                  children: [
                    Lottie.asset(
                      'assets/graph.json',
                      repeat: true,
                      height: 210,
                    ),
                    Text(
                      "Visualize",
                      style: GoogleFonts.tomorrow(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Define action for the third container
              },
              child: _buildRoundedContainer(
                height / 3,
                width / 5.1,
                Colors.transparent,
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/orb.json',
                        repeat: true,
                        height: 210,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
                          // Define action for the button
                        },
                        child: Text(
                          "Converse Now",
                          style: GoogleFonts.tomorrow(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundedContainer(double height, double width, Color color,
      [Widget? child]) {
    return Container(
      height: height,
      width: width,
      margin:
      EdgeInsets.symmetric(horizontal: 8.0), // Add space between containers
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: color.withOpacity(0.2),
            child: child,
          ),
        ),
      ),
    );
  }
}
