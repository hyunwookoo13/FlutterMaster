import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: Center(
        child: AvatarGlow(
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.orangeAccent,
            backgroundImage: AssetImage('assets/images/myAvatar.jpeg'),
          ),
          endRadius: 100,
          glowColor: Colors.deepPurple,
          duration: Duration(milliseconds: 2000),
          repeatPauseDuration: Duration(milliseconds: 100),
        ),
      ),
    );
  }
}
