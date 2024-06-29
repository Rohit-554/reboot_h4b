import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:tiktik_v/api_service/ApiService.dart';
import 'package:tiktik_v/data/model/Chat_response_model.dart';
import 'package:tiktik_v/presentation/settingsPage.dart';
import 'package:tiktik_v/presentation/use_case/get_chat_use_case.dart';
import 'package:tiktik_v/provider/StateProviders.dart';

import '../injection_container.dart';
import '../utils/responsive.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  List<bool> isSelected = [true, false];
  late Future<List<String>?> _botResponse;

  @override
  void initState() {
    super.initState();
    print("ChatId data ${ref.read(chatIdProvider)}");
  }

  void fromUserText({required String query}) {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({
          "role": "You",
          "text": _controller.text,
        });
        _controller.clear();
      });
      _botResponse = getAiResponse(ref, query);
    }
  }

  Future<List<String>?> getAiResponse(WidgetRef ref, String query) async {
    final chatUseCase = sl<GetChatUseCase>();
    var chatResponse = await chatUseCase.execute(
        chatId: ref.read(chatIdProvider), query: query);
    print("chatREsponse ${chatResponse}");
    if (chatResponse != null) {
      var len = chatResponse.length;
      setState(() {
        for (int i = 0; i < len; i++) {
          _messages.add({
            "role": "Bot",
            "text": chatResponse[i] ?? "Error: No response",
          });
        }
      });
    }
    return chatResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF252525),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle:  Responsive.isDesktop(context)? false:true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Converse With",
          style: GoogleFonts.tomorrow(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize:Responsive.isDesktop(context)?32: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        actions: [
          Container(
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConnectionScreen()));
              },
            ),
          ),
        ],
        leading: SizedBox(
          height: 120,
          child: Lottie.asset(
            'assets/orb.json',
            repeat: true,
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
                            bottomRight: Radius.circular(5),
                          )
                        : const BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(5),
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
                                  color:
                                      isUser ? Color(0xFFD7FE62) : Colors.white,
                                  borderRadius: borderRadius,
                                ),
                                child: MarkdownBody(
                                  data: _messages[index]["text"]!,
                                  styleSheet: MarkdownStyleSheet(
                                    tableHead: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Color(0xFF252525),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    tableBody: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Color(0xFF252525),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    tableHeadAlign: TextAlign.center,
                                    tableBorder: TableBorder.all(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(15),
                                        width: 0.5),
                                    p: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Color(0xFF252525),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    h1: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    h2: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    h3: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    code: GoogleFonts.sourceCodePro(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      color: Colors.green,
                                      // backgroundColor: Colors.black26,
                                    ),
                                    codeblockPadding: const EdgeInsets.all(8),
                                    codeblockDecoration: BoxDecoration(
                                      color: Colors.black26,
                                    ),
                                    blockquote: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    listBullet: GoogleFonts.poppins(
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
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(50),
                    //       color: Colors.white.withOpacity(0.4),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.black12,
                    //           blurRadius: 4,
                    //           offset: Offset(2, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     child: IconButton(
                    //       icon: const Icon(
                    //         Icons.upload,
                    //         size: 32,
                    //         color: Colors.white54,
                    //       ),
                    //       onPressed: () {
                    //         // Add your image upload functionality here
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
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
                                Radius.circular(50.0),
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
                            color: Color(0xFFD7FE62),
                            width: 2.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white.withOpacity(0.4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
