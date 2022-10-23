import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const double stageSize = 300;
const double size = 30;
const double wallHeight = 60;

enum Direction {
  up,
  down,
  none,
}

enum GameState {
  running,
  dead,
}

class _MyHomePageState extends State<MyHomePage> {
  double marioY = stageSize;
  double wallX = stageSize;
  Direction direction = Direction.none;
  GameState gameState = GameState.running;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var duration = const Duration(milliseconds: 5);
    Timer.periodic(
      duration,
      (timer) {
        double newMarioY = marioY;
        Direction newDirection = direction;
        switch (direction) {
          case Direction.up:
            newMarioY--;
            if (newMarioY < 100) {
              newDirection = Direction.down;
            }
            break;
          case Direction.down:
            newMarioY++;
            if (newMarioY > stageSize) {
              newDirection = Direction.none;
            }
            break;
        }

        if (wallX < size && marioY > stageSize - wallHeight) {
          setState(() {
            gameState = GameState.dead;
          });
        }
        setState(() {
          wallX = (wallX - 1 + stageSize) % stageSize;
          marioY = newMarioY;
          direction = newDirection;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: gameState == GameState.running
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    direction = Direction.up;
                  });
                },
                child: Container(
                  width: stageSize,
                  height: stageSize,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fromRect(
                        rect: Rect.fromCenter(
                          center: Offset(size / 2, marioY - size / 2),
                          width: size,
                          height: size,
                        ),
                        child: Container(
                          color: Colors.orange,
                        ),
                      ),
                      Positioned.fromRect(
                        rect: Rect.fromCenter(
                          center: Offset(
                              wallX - size / 2, stageSize - wallHeight / 2),
                          width: size,
                          height: wallHeight,
                        ),
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 64,
                  color: Colors.red,
                ),
              ),
      ),
    );
  }
}
