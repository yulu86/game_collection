import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_collection/src/ball.dart';
import 'package:game_collection/src/ball_state.dart';
import 'package:game_collection/src/rocket.dart';
import 'package:game_collection/src/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PingPong',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const double rocketStep = 0.1;
const double ballStep = 0.02;
const double maxY = 0.95;
const double minY = -0.95;
const rocketLength = 1 / 3;

class _MyHomePageState extends State<MyHomePage> {
  double _upRocketX = 0;
  double _downRocketX = 0;
  bool _isRunning = false;
  final BallState _ballState = BallState();
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: _onKey,
        child: SafeArea(
          child: GestureDetector(
            onTap: _startGame,
            child: Stack(
              children: [
                // 启动界面
                StartScreen(isShow: _isRunning),
                // 顶部的球拍
                Rocket(x: _upRocketX, y: minY, color: Colors.red),
                // 乒乓球
                Ball(x: _ballState.ballX, y: _ballState.ballY),
                // 底部的球拍
                Rocket(x: _downRocketX, y: maxY, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startGame() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) => _updateBall(),
    );
  }

  void _updateBall() {
    setState(() {
      _ballState.update();
      bool isCollision = _ballState.checkCollision(_upRocketX, _downRocketX);
      if (isCollision) {
        _stopGame();
      }
    });
  }

  void _stopGame() {
    _isRunning = false;
    _timer.cancel();
    setState(_reset);
  }

  void _reset() {
    _upRocketX = 0;
    _downRocketX = 0;
    _ballState.reset();
  }

  void _onKey(RawKeyEvent? event) {
    if (event.runtimeType == RawKeyDownEvent) {
      final keyLabel = event?.logicalKey.keyLabel;
      double newDownRocketX = _downRocketX;
      double newUpRocketX = _upRocketX;
      if (_ballState.vDirection == Direction.down) {
        newDownRocketX = _getNewRocketX(_downRocketX, keyLabel);
      } else if (_ballState.vDirection == Direction.up) {
        newUpRocketX = _getNewRocketX(_upRocketX, keyLabel);
      }

      setState(() {
        _downRocketX = newDownRocketX;
        _upRocketX = newUpRocketX;
      });
    }
  }

  double _getNewRocketX(double oldRocketX, String? keyLabel) {
    if (keyLabel == "Arrow Left") {
      return oldRocketX - rocketStep;
    } else if (keyLabel == "Arrow Right") {
      return oldRocketX + rocketStep;
    }
    return oldRocketX;
  }
}
