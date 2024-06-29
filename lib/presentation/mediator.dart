import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../utils/responsive.dart';
import 'chat_page.dart';

class MediatorPage extends StatefulWidget {
  const MediatorPage({super.key});

  @override
  State<MediatorPage> createState() => _MediatorPageState();
}

class _MediatorPageState extends State<MediatorPage>
    with WidgetsBindingObserver {
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xff181818),
      appBar: AppBar(
        centerTitle: Responsive.isDesktop(context) ? false : true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Converse With",
          style: GoogleFonts.tomorrow(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: Responsive.isDesktop(context) ? 32 : 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hero.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildWelcomeSection(height),
                const SizedBox(height: 16),
                _buildContentSections(context, height, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(double height) {
    return Container(
      height: height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF212121),
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _getGreeting(),
                style: GoogleFonts.hankenGrotesk(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Responsive.isDesktop(context)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Current Sales: 38824',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )),
                        const SizedBox(width: 20),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Stocks of socks depleceting',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )),
                        const SizedBox(width: 20),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Customers are loving your products!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Current Sales: 38824',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )),
                        const SizedBox(height: 20),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Stocks of socks depleceting',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )),
                        const SizedBox(height: 20),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Customers are loving your products!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSections(
      BuildContext context, double height, double width) {
    if (Responsive.isDesktop(context)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionContainer(
              height / 3,
              width / 2.2,
              Colors.transparent,
              _buildLottieContent('assets/dino.json', 'Switch to Offline'),
              () {}),
          _buildActionContainer(height / 3, width / 5.1, Colors.transparent,
              _buildLottieContent('assets/graph.json', 'Visualize'), () {}),
          _buildActionContainer(height / 3, width / 5.1, Colors.transparent,
              _buildLottieContent('assets/orb.json', 'Converse Now'), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ChatPage()));
          }),
        ],
      );
    } else {
      return Column(
        children: [
          _buildActionContainer(
              height / 3,
              width,
              Colors.transparent,
              _buildLottieContent('assets/dino.json', 'Switch to Offline'),
              () {}),
          const SizedBox(height: 20),
          _buildActionContainer(height / 3, width, Colors.transparent,
              _buildLottieContent('assets/graph.json', 'Visualize'), () {}),
          const SizedBox(height: 20),
          _buildActionContainer(height / 3, width, Colors.transparent,
              _buildLottieContent('assets/orb.json', 'Converse Now'), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ChatPage()));
          }),
        ],
      );
    }
  }

  Widget _buildLottieContent(String assetPath, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          assetPath,
          repeat: true,
          height: 210,
        ),
        Text(
          label,
          style: GoogleFonts.tomorrow(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionContainer(double height, double width, Color color,
      Widget child, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
      ),
    );
  }
}
