import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktik_v/presentation/use_case/connect_to_database_use_case.dart';
import 'package:tiktik_v/presentation/use_case/get_chat_use_case.dart';
import 'package:tiktik_v/provider/StateProviders.dart';

import '../injection_container.dart';


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
  initTextControllers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    host.text = ref.read(hostProvider);
    user.text = ref.read(userProvider);
    password.text = ref.read(passwordProvider);
    dataBase.text = ref.read(databaseProvider).toString();
  }


  updateProviders() {
    ref.read(hostProvider.notifier).state = host.text;
    ref.read(userProvider.notifier).state = user.text;
    ref.read(passwordProvider.notifier).state = password.text;
    ref.read(databaseProvider.notifier).state = dataBase.text;
  }

  @override
  void initState() {
    super.initState();
    initTextControllers();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isConnectedToLg = ref.watch(isDatabaseConnected);
    double paddingValue = width * 0.2;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                customInput(host, "Host"),
                customInput(user, "User"),
                customInput(password, "Password"),
                customInput(dataBase, "Database"),
                /*customInput(chatUserNameController, "Enter your name"),*/
                Padding(
                  padding:  EdgeInsets.only(left: paddingValue, right: paddingValue, top: 10, bottom: 10),
                  child: SizedBox(
                    height: 48,
                    width: width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ref.read(isDatabaseConnected) ? Colors.redAccent : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        updateProviders();
                        if (!ref.read(isDatabaseConnected)) {
                          setState(() {
                            isLoading = true;
                          });
                          _connectToDatabase(ref,host.text,user.text,password.text,dataBase.text);
                        }
                      },
                      child: const Text(
                        "Connect To Database",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customInput(TextEditingController controller, String labelText) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double paddingValue = width * 0.2;
    return Padding(
      padding:  EdgeInsets.only(left: paddingValue, right: paddingValue, top: 10, bottom: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white), // Text color
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
}

void _connectToDatabase(WidgetRef ref, String host, String user, String password, String database) async{

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
    if(response.data!.isNotEmpty){
      print("ChatId${response.data}");
      ref.read(chatIdProvider.notifier).state = response.data!;
      ref.read(isDatabaseConnected.notifier).state = true;
    }
    // var chatResponse = await chatUseCase.execute(chatId: response.data!, query: "Which is the best performing product in terms of revenue?");
    // print("Chatresponse${chatResponse.data}");
  }catch(e){
    print(e);
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