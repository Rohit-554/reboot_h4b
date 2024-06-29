import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktik_v/injection_container.dart';
import 'package:tiktik_v/presentation/LandingPage.dart';
import 'package:tiktik_v/presentation/mediator.dart';
import 'package:tiktik_v/theme/appTheme.dart';


void main() async{
  await initializeDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TikTik_V',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundColor,
          textTheme: GoogleFonts.poppinsTextTheme().apply(
            bodyColor: AppColors.textColor,
          ),
          appBarTheme: appBarTheme(),
          useMaterial3: true,
        ),
        home: const MediatorPage()
    );
  }
}
