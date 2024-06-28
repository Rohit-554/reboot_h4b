import 'package:flutter/material.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:tiktik_v/presentation/use_case/connect_to_database_use_case.dart';
import 'package:tiktik_v/presentation/use_case/get_chat_use_case.dart';

import '../injection_container.dart';
import '../utils/responsive.dart';



class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _connectToDatabase();
  }

  void _connectToDatabase() async{
    final useCase = sl<ConnectToDatabaseUseCase>();
    final chatUseCase = sl<GetChatUseCase>();

    try {
      var response = await useCase.execute(
        host: 'ms.itversity.com',
        user: 'retail_user',
        password: 'itversity',
        database: 'retail_db',
      );
      print("Response${response.data}");
      var chatResponse = await chatUseCase.execute(chatId: response.data!, query: "Which is the best performing product in terms of revenue?");
      print("Chatresponse${chatResponse.data}");
    }catch(e){
      print(e);
    }

  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff181818),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        // leading: const CircleAvatar(
        //   foregroundColor: Colors.pink,
        // ),
        // actions: [
        //   CustomButton(
        //     onPressed: () {},
        //     title: 'Continue',
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _largeImageSection(context, height),
                      Column(
                        children: [
                          SizedBox(
                            width: width*0.8,
                            child: Image.asset(
                              'assets/pc.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 40,),
                          _startButton(context),

                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _sectionOne(context),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.1),
              SizedBox(height: height * 0.1),
              _featureSection(context, height),
              SizedBox(height: height * 0.1),
              _contentSection(context, height),
              SizedBox(height: height * 0.1),
              _testimonials(),
              SizedBox(height: height * 0.1),
              _footer(height, width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionOne(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 28.0),
          child: Text("Revolutionizing the way of database",textAlign: TextAlign.center,
              style: TextStyle(

                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
        ),
        Text('This is a subtitle',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _startButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          title: "Try Now",
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
          },
        ),
      ],
    );
  }

  Widget _largeImageSection(BuildContext context, double height) {
    return  Responsive.isDesktop(context)? Container(
        height: height,
        width: double.infinity,
        color: Colors.transparent,
        child: Image.asset(
          'assets/hero.png',
          fit: BoxFit.cover,
        )): Container(
        height: height,
        width: double.infinity,
        color: Colors.transparent,
        child: Image.asset(
          'assets/hero.png',
          fit: BoxFit.cover,
        ));
  }

  Widget _featureSection(BuildContext context, double height) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Responsive.isDesktop(context)? Column(
        children: <Widget>[
          const TitleSubtitle(
              title: "Features",
              subtitle: "Heuheuheu This is a feature subtitle"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  height: height * 0.5,
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/hero.png',
                    fit: BoxFit.cover,
                  )),
              Column(
                children: [
                  featureItem(
                    title: "Feature 1",
                    subtitle: "This is a feature subtitle",
                    icon: Icons.restaurant,
                  ),
                  const SizedBox(height: 20),
                  featureItem(
                    title: "Feature 2",
                    subtitle: "This is a feature subtitle",
                    icon: Icons.ac_unit,
                  ),
                  const SizedBox(height: 20),
                  featureItem(
                    title: "Feature 3",
                    subtitle: "This is a feature subtitle",
                    icon: Icons.face_unlock_outlined,
                  ),
                ],
              ),
            ],
          )
        ],
      ):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const TitleSubtitle(
              title: "Features",
              subtitle: "Heuheuheu This is a feature subtitle"),
          const SizedBox(height: 20),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                      height: height * 0.5,
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/hero.png',
                        fit: BoxFit.cover,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4,left: 32.0),
                  child: Center(
                    child: Column(
                      children: [
                        featureItem(
                          title: "Feature 1",
                          subtitle: "This is a feature subtitle",
                          icon: Icons.restaurant,
                        ),
                        const SizedBox(height: 20),
                        featureItem(
                          title: "Feature 2",
                          subtitle: "This is a feature subtitle",
                          icon: Icons.ac_unit,
                        ),
                        const SizedBox(height: 20),
                        featureItem(
                          title: "Feature 3",
                          subtitle: "This is a feature subtitle",
                          icon: Icons.face_unlock_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget featureItem(
      {required String title,
        required String subtitle,
        required IconData icon}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF02e4c0), size: 20),
            const SizedBox(width: 10),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        const SizedBox(height: 8),
        Text(subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
      ],
    );
  }

  Widget _contentSection(BuildContext context,double height) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child:   Responsive.isDesktop(context)?const Column(children: <Widget>[
        TitleSubtitle(title: "Contents", subtitle: "This is a content subtitle"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCard(
                title: "Work", subtitle: "This is a blablabla", icon: Icons.work),
            CustomCard(
                title: "Work", subtitle: "This is a blablabla", icon: Icons.work),
          ],
        )
      ]):const Column(children: <Widget>[
        TitleSubtitle(title: "Contents", subtitle: "This is a content subtitle"),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCard(
                title: "Work", subtitle: "This is a blablabla", icon: Icons.work),
            CustomCard(
                title: "Work", subtitle: "This is a blablabla", icon: Icons.work),
          ],
        )
      ]),
    );
  }

  Widget _testimonials()  {
    return  Responsive.isDesktop(context)? const Column(
      children: <Widget>[
        TitleSubtitle(title: "Team Reboot", subtitle: "About Us"),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomProfileBorderCard(
                    name: "Sai Kishan",
                    role: "Flutter Dev & UI/UX",
                    description: "Design and Code Beautiful",
                    imageUrl: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=Patches"),
                CustomProfileBorderCard(
                    name: "Ujjwal Kumar Singh",
                    role: "Backend Lord",
                    description: "Kneel before the lord!",
                    imageUrl: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=Missy")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomProfileBorderCard(
                    name: "Rohit Kumar",
                    role: "Flutter dev",
                    description: "I am very weird person, don't touch my code",
                    imageUrl: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=Tigger"),
                CustomProfileBorderCard(
                    name: "Saumya Bhattacharya",
                    role: "Flutter Dev",
                    description:
                    "Debugging through chaos, one widget at a time.",
                    imageUrl: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=Baby")
              ],
            ),
          ],
        )
      ],
    ): const Column(
      children: <Widget>[
        TitleSubtitle(title: "Team Reboot", subtitle: "About Us"),
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomProfileBorderCard(
                    name: "Sai Kishan",
                    role: "Flutter Dev & UI/UX",
                    description: "Design and Code Beautiful",
                    imageUrl: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=Patches"),
                CustomProfileBorderCard(
                    name: "Ujjwal Kumar Singh",
                    role: "Backend Lord",
                    description: "Kneel before the lord!",
                    imageUrl: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=Missy")
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomProfileBorderCard(
                    name: "Rohit Kumar",
                    role: "Flutter dev",
                    description: "I am very weird person, don't touch my code",
                    imageUrl: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=Tigger"),
                CustomProfileBorderCard(
                    name: "Saumya Bhattacharya",
                    role: "Flutter Dev",
                    description:
                    "Debugging through chaos, one widget at a time.",
                    imageUrl: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=Baby")
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _footer(double height, double width) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF343434),
          borderRadius: BorderRadius.circular(10),
        ),
        width:
        width * 0.9, // Adjusted width to ensure it fits within the screen
        height: height * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OpenType feature\nand Variable fonts",
                    style: TextStyle(color: Colors.white, fontSize: Responsive.isDesktop(context)? 36:20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6A65FF),
                      shape: const BeveledRectangleBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      "Try Now",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Responsive.isDesktop(context)?
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://placehold.co/1000x1000',
                    fit: BoxFit.cover,
                    width: width * 0.35, // Adjust as needed
                    height: height * 0.25, // Adjust as needed
                  ),
                ),
              ),
            ): Container(),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String title;
  final bool isBorderOnly;
  const CustomButton({
    super.key,
    required this.onPressed,
    this.color = const Color(0xff4452FE),
    required this.title,
    this.isBorderOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: color, // text color
            padding: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: isBorderOnly
                  ? const BorderSide(color: Colors.white, width: 2)
                  : const BorderSide(color: Colors.transparent),
            ),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}

class TitleSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleSubtitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        const SizedBox(height: 20),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const CustomCard(
      {super.key,
        required this.title,
        required this.subtitle,
        required this.icon});

  @override
  Widget build(BuildContext context) {

    return AnimatedGradientBorder(
      borderSize: 0.2,
      glowSize: 10,
      gradientColors: [
        Colors.purpleAccent,
        const Color(0xff6A65FF),
        const Color(0xff6A65FF),
        Colors.purple.shade50
      ],
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: SizedBox(
        width: 350,
        height: 200,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.black, size: 20),
                    const SizedBox(width: 10),
                    Text(title,
                        style:
                        const TextStyle(color: Colors.black, fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(subtitle,
                    style: const TextStyle(color: Colors.black, fontSize: 15)),
                // Spacer(),
                // CustomButton(onPressed: (){},title: "Sign Up",),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomProfileBorderCard extends StatelessWidget {
  final String name;
  final String role;
  final String description;
  final String imageUrl;

  const CustomProfileBorderCard({
    super.key,
    required this.name,
    required this.role,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 350,
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                      Text(role,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
