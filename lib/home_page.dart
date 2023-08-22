import 'package:avatar_glow/avatar_glow.dart';
import 'package:avatar_glow_package/game/coconut_game_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CoconutGamePage()));
              },
              child: AvatarGlow(
                endRadius: 100,
                glowColor: Colors.deepPurple,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.orangeAccent,
                  backgroundImage: AssetImage('assets/images/myAvatar.jpeg'),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ModalContent();
                },
              );
            },
            child: Text('Open Modal'),
          ),
        ],
      ),
    );
  }
}

class ModalContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Modal Content'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              //Navigator.pop(context); // Close the current modal

              const begin = Offset(-1.0, 0.0); // 시작점을 왼쪽(-X)으로 수정
              const end = Offset(0.0, 0.0);
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = ModalRoute.of(context)!.animation!.drive(tween);


              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FullScreenModalContent(),
                  );
                },
              );
            },
            child: Text('Open Next Modal'),
          ),
        ],
      ),
    );
  }
}

class FullScreenModalContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('코드를 입력해주세요:)'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the current modal
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

