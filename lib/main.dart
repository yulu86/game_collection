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
  double _marioY = stageSize;
  double _wallX = stageSize;
  Direction _direction = Direction.none;
  GameState _gameState = GameState.running;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var duration = const Duration(milliseconds: 5);
    Timer.periodic(
      duration,
      (timer) {
        double newMarioY = _marioY;
        Direction newDirection = _direction;
        switch (_direction) {
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
          case Direction.none:
            break;
        }

        if (_wallX < size && _marioY > stageSize - wallHeight) {
          setState(() {
            _gameState = GameState.dead;
          });
        }
        setState(() {
          _wallX = (_wallX - 1 + stageSize) % stageSize;
          _marioY = newMarioY;
          _direction = newDirection;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _gameState == GameState.running
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _direction = Direction.up;
                  });
                },
                child: GameScreen(
                  marioY: _marioY,
                  wallX: _wallX,
                ),
              )
            : const GameOverPanel(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({
    Key? key,
    required this.marioY,
    required this.wallX,
  }) : super(key: key);

  final double marioY;
  final double wallX;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: stageSize,
      height: stageSize,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black,
        ),
      ),
      child: GameContent(
        marioY: marioY,
        wallX: wallX,
      ),
    );
  }
}

class GameContent extends StatelessWidget {
  const GameContent({
    Key? key,
    required this.marioY,
    required this.wallX,
  }) : super(key: key);

  final double marioY;
  final double wallX;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Mario(marioY: marioY),
        Wall(wallX: wallX),
      ],
    );
  }
}

class Mario extends StatelessWidget {
  const Mario({Key? key, required this.marioY}) : super(key: key);

  final double marioY;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: Offset(size / 2, marioY - size / 2),
        width: size,
        height: size,
      ),
      child: Container(
        color: Colors.orange,
      ),
    );
  }
}

class Wall extends StatelessWidget {
  const Wall({Key? key, required this.wallX}) : super(key: key);

  final double wallX;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: Offset(wallX - size / 2, stageSize - wallHeight / 2),
        width: size,
        height: wallHeight,
      ),
      child: Container(
        color: Colors.black,
      ),
    );
  }
}

class GameOverPanel extends StatelessWidget {
  const GameOverPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Game Over',
      style: TextStyle(
        fontSize: 64,
        color: Colors.red,
      ),
    );
  }
}
