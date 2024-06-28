import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tiktik_v/presentation/settingsPage.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage> {

  final List<Map<String, String>> _messages = []; // List to hold message maps
  final TextEditingController _controller = TextEditingController();
  List<bool> isSelected = [true, false];

  void fromUserText({required String query}) {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({
          "role": "You", // Assuming "You" as the role for user messages
          "text": _controller.text,
        });
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252525),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),

          child:
          ToggleButtons(
            borderColor: Colors.grey,
            selectedBorderColor: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            fillColor: Colors.grey[300],
            selectedColor: Colors.black,
            color: Colors.black,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 100.0,
            ),
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }
              });
            },
            children: <Widget>[
              Text(
                'Chat',
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected[0] ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Visualize',
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected[1] ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white.withOpacity(0.4),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.settings,
                  size: 32,
                  color: Colors.white54,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionScreen()));
                },
              ),
            ),
          ),
        ],
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFD7FE62),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: _messages.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemBuilder: (context, index) {
                    final isUser = _messages[index]["role"] == "You";
                    final borderRadius = isUser
                        ? const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(10),
                    )
                        : const BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(10),
                    );

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 50,
                              minHeight: 35,
                            ),
                            child: Padding(
                              padding: isUser
                                  ? const EdgeInsets.only(left: 30.0)
                                  : const EdgeInsets.only(right: 30.0),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFD7FE62),
                                  borderRadius: borderRadius,
                                ),
                                child: Text(
                                  _messages[index]["text"]!,
                                  style: GoogleFonts.sourceCodePro(
                                    textStyle: TextStyle(
                                      color: Color(0xFF252525),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),

                          color: Colors.white.withOpacity(0.4),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.upload,
                            size: 32,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            // Add your image upload functionality here
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(50),

                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Color(0xFFD7FE62),  // You can change the color of the border
                            width: 2.0,           // Adjust the width of the border
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.mic,
                            size: 32,
                            color: Color(0xFFD7FE62),
                          ),
                          onPressed: () {
                            // Add your speech input functionality here
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white.withOpacity(0.4),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            size: 32,
                            color: Color(0xFFD7FE62),
                          ),
                          onPressed: () {
                            if (_controller.text.trim().isNotEmpty) {
                              fromUserText(query: _controller.text);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


