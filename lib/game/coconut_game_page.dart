import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CoconutGamePage extends StatefulWidget {
  const CoconutGamePage({Key? key}) : super(key: key);

  @override
  State<CoconutGamePage> createState() => _CoconutGamePageState();
}

class _CoconutGamePageState extends State<CoconutGamePage> {

  int score = 0;
  int lives = 3;
  int stage = 1;
  double bombSpeed = 2.0;
  bool gamePaused = false;


  List<Coconut> coconuts = [];
  List<Bomb> bombs = [];

  int coconutInterval = 30; // Interval in ticks to add a new coconut
  int bombInterval = 60;    // Interval in ticks to add a new bomb
  int tickCount = 0;        // Keeps track of game ticks

  double playerPosition = 0.5; // Initial player position (0 to 1)

  void startGame() {
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (!gamePaused) {
        setState(() {
          playerPosition += 0.005;
          if (playerPosition > 1.0) {
            playerPosition = 1.0;
          }
          updateCoconutsAndBombs();
          checkCollisions();
        });
      }
    });
  }

  void resetGame() {
    playerPosition = 0.5;
  }

  void increaseStage() {
    stage++;
    bombSpeed += 0.1;
  }

  bool isCollision() {
    // Check collision logic here
    return false;
  }

  bool isCoconutCollected() {
    // Check coconut collected logic here
    return false;
  }

  void updateCoconutsAndBombs() {
    tickCount++;

    if (tickCount % coconutInterval == 0 && coconuts.length < 5) {
      coconuts.add(Coconut());
    }

    if (tickCount % bombInterval == 0 && bombs.length < 5) {
      bombs.add(Bomb());
    }

    for (int i = 0; i < coconuts.length; i++) {
      coconuts[i].updatePosition();
    }

    for (int i = 0; i < bombs.length; i++) {
      bombs[i].updatePosition();
    }

    // Remove off-screen coconuts and bombs
    coconuts.removeWhere((coconut) => coconut.y > 600);
    bombs.removeWhere((bomb) => bomb.y > 600);
  }

  void checkCollisions() {
    for (int i = 0; i < coconuts.length; i++) {
      if (coconuts[i].y > 560 && coconuts[i].x == playerPosition) {
        score++;
        coconuts.removeAt(i);
      }
    }

    for (int i = 0; i < bombs.length; i++) {
      if (bombs[i].y > 560 && bombs[i].x == playerPosition) {
        lives--;
        if (lives == 0) {
          // Game over logic
        }
        bombs.removeAt(i);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coconut Game'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/coconut/coconut_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Score: $score'),
                  Text('Lives: $lives'),
                  Text('Stage: $stage'),
                  GestureDetector(
                    onHorizontalDragUpdate:(DragUpdateDetails details){
                      playerPosition = details.localPosition.dx / 300;
                      if (playerPosition < 0.0) {
                        playerPosition = 0.0;
                      } else if (playerPosition > 1.0) {
                        playerPosition = 1.0;
                      }
                      setState(() {});
                    },
                    child: Container(
                      height: 400,
                      width: 300,
                      child: Stack(
                        children: [
                          Positioned(
                            left: playerPosition * 300 - 20,
                            bottom: 0,
                            child: Image.asset(
                              "assets/coconut/yaja.png",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (var coconut in coconuts)
              Positioned(
                left: coconut.x * 300,
                top: coconut.y,
                child: Image.asset(
                  "assets/coconut/sky_coconut.png",
                  width: 40,
                  height: 40,
                ),
              ),
            for (var bomb in bombs)
              Positioned(
                left: bomb.x * 300,
                top: bomb.y,
                child: Image.asset(
                  "assets/coconut/sky_bomb.png",
                  width: 40,
                  height: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Coconut {
  late double x;
  late double y;
  late double speed;

  Coconut() {
    x = Random().nextDouble();
    y = 0;
    speed = 1.0;
  }

  void updatePosition() {
    y += speed;
  }
}

class Bomb {
  late double x;
  late double y;
  late double speed;

  Bomb() {
    x = Random().nextDouble();
    y = 0;
    speed = 1.5;
  }

  void updatePosition() {
    y += speed;
  }
}