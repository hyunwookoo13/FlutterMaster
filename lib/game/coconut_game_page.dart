import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CoconutGamePage extends StatefulWidget {
  const CoconutGamePage({Key? key}) : super(key: key);

  @override
  State<CoconutGamePage> createState() => _CoconutGamePageState();
}

class _CoconutGamePageState extends State<CoconutGamePage> {
  var gameOver = false;
  var time = 10;
  int score = 0;
  int lives = 3;
  int stage = 1;
  double bombSpeed = 2.0;
  bool gamePaused = false;

  static const double playerWidth = 30.0; // 플레이어의 가로 크기
  static const double playerHeight = 60.0; // 플레이어의 세로 크기
  static const double coconutWidth = 30.0; // 대나무 마디의 가로 크기
  static const double coconutHeight = 60.0; // 대나무 마디의 세로 크기
  static const double boundaryHeight = 550; // 경계선 높이
  static const double boundaryWidth = 220; // 경계선 가로 길이
  double boundaryPadding = 60; // 경계 양쪽 패딩
  double playerPosition = 0.0; // 플레이어의 좌우 위치
  double bambooGridWeight = 1;

  List<Coconut> coconuts = [];
  List<Bomb> bombs = [];

  int coconutInterval = 30; // Interval in ticks to add a new coconut
  int bombInterval = 60;    // Interval in ticks to add a new bomb
  int tickCount = 0;        // Keeps track of game ticks

  //double playerPosition = 0.5; // Initial player position (0 to 1)

  void calcDeviceSize() {
    boundaryPadding = (MediaQuery.of(context).size.width - boundaryWidth) / 2;
    playerPosition = MediaQuery.of(context).size.width / 2 - playerWidth / 2;
    bambooGridWeight = (MediaQuery.of(context).size.width - boundaryPadding * 2) / 9;
    setState(() {});
  }

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

    Future.delayed(Duration.zero, () {
      calcDeviceSize();
      //startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Coconut Game'),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          playerPosition += details.delta.dx;
          if (playerPosition < boundaryPadding - coconutWidth / 2) playerPosition = boundaryPadding - coconutWidth / 2;
          if (playerPosition > MediaQuery.of(context).size.width - playerWidth - boundaryPadding + coconutWidth / 2) {
            playerPosition = MediaQuery.of(context).size.width - playerWidth - boundaryPadding + coconutWidth / 2;
          }
          setState(() {});
        },
        child: Stack(
          children: [
            AnimatedContainer(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/coconut/coconut_background.png"),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  colors: [
                    time > 5 ? Colors.transparent : const Color(0x0DDB5555),
                    Color(time > 5 ? 0x4D55DB82 : 0x4DDB5555),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
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

            // 플레이어
            if (!gameOver)
              Positioned(
                top: boundaryHeight - playerHeight,
                left: playerPosition - playerWidth,
                child: Container(
                  width: playerWidth * 3,
                  // height: playerHeight * 3,
                  color: Colors.transparent,
                  child: Image.asset('assets/coconut/yaja.png'),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Score: $score'),
                  Text('Lives: $lives'),
                  Text('Stage: $stage'),
                ],
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