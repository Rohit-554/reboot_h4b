import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktik_v/presentation/use_case/connect_to_database_use_case.dart';
import 'package:tiktik_v/presentation/use_case/get_chat_use_case.dart';
import 'package:tiktik_v/provider/StateProviders.dart';
import '../injection_container.dart';
import '../utils/responsive.dart';
import 'mediator.dart';

class ConnectionScreen extends ConsumerStatefulWidget {
  const ConnectionScreen({super.key});

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends ConsumerState<ConnectionScreen> {
  bool isLoading = false;
  TextEditingController host = TextEditingController(text: '');
  TextEditingController user = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController dataBase = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    initTextControllers();
  }

  Future<void> initTextControllers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    host.text = ref.read(hostProvider);
    user.text = ref.read(userProvider);
    password.text = ref.read(passwordProvider);
    dataBase.text = ref.read(databaseProvider).toString();
  }

  void updateProviders() {
    ref.read(hostProvider.notifier).state = host.text;
    ref.read(userProvider.notifier).state = user.text;
    ref.read(passwordProvider.notifier).state = password.text;
    ref.read(databaseProvider.notifier).state = dataBase.text;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isConnectedToLg = ref.watch(isDatabaseConnected);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Connect to Database',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bgAnim.gif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: height,
              color: Colors.black.withOpacity(0.7), // Adjust the opacity as needed
            ),
            Center(
              child: Padding(
                padding: Responsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: 100.0,vertical: 20):EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                child: Container(
                  width: Responsive.isDesktop(context) ?600:400,
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            customInput(host, "Host"),
                            customInput(user, "User"),
                            customInput(password, "Password"),
                            customInput(dataBase, "Database"),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                height: 48,
                                width: width * 0.6,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isConnectedToLg ? Colors.redAccent : Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    updateProviders();
                                    if (isConnectedToLg) {
                                      _disconnectFromDatabase(ref);
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      _connectToDatabase(ref, host.text, user.text, password.text, dataBase.text).then((_) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MediatorPage()),
                                        );
                                      });
                                    }
                                  },
                                  child: isLoading
                                      ? CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                    isConnectedToLg ? "Disconnect" : "Connect To Database",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customInput(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Color(0xFF2D2F3A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    user.dispose();
    password.dispose();
    host.dispose();
    dataBase.dispose();
    super.dispose();
  }

  Future<void> _connectToDatabase(WidgetRef ref, String host, String user, String password, String database) async {
    final useCase = sl<ConnectToDatabaseUseCase>();
    final chatUseCase = sl<GetChatUseCase>();

    try {
      var response = await useCase.execute(
        host: host,
        user: user,
        password: password,
        database: database,
      );
      print("Response${response.data}");
      if (response.data!.isNotEmpty) {
        print("ChatId${response.data}");
        ref.read(chatIdProvider.notifier).state = response.data!;
        ref.read(isDatabaseConnected.notifier).state = true;
      }
    } catch (e) {
      print(e);
    }
  }

  void _disconnectFromDatabase(WidgetRef ref) {
    ref.read(chatIdProvider.notifier).state = '';
    ref.read(isDatabaseConnected.notifier).state = false;
  }
}

class ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final bool isShutdown;
  final VoidCallback onPressed;

  const ControlButton({
    required this.icon,
    required this.label,
    this.isPrimary = false,
    required this.onPressed,
    this.isShutdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth * 0.2;
    final buttonHeight = screenHeight * 0.1;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: buttonHeight,
        width: buttonWidth,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 24),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            foregroundColor: isShutdown ? Colors.white : (isPrimary ? Colors.white : Colors.black),
            backgroundColor: isShutdown ? Colors.red : (isPrimary ? Colors.blue : Colors.white),
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
