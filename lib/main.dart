import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake'),
      ),
      body: const SnakeGame(),
    );
  }
}

const double size = 10;

enum Direction {
  up,
  down,
  left,
  right,
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  Offset _ball = Offset.zero;
  List<Offset> _snake = [
    const Offset(50, 0),
    const Offset(60, 0),
  ];
  Direction _snakeDirection = Direction.left;
  late Timer _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final maxWidth = _getMaxWidth();
    final maxHeight = _getMaxHeight();
    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        List<Offset> newOffset = _updateSnakePosition(maxWidth, maxHeight);
        Offset newBall = _ball;
        if (newOffset[0] == _ball) {
          newOffset.add(_snake[_snake.length - 1]);
          newBall = _randomBall(maxWidth.toInt(), maxHeight.toInt());
        }
        setState(() {
          _snake = newOffset;
          _ball = newBall;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> snake = _getSnake();
    Widget ball = _getBall();
    snake.add(ball);
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: _onKey,
      child: Stack(
        children: snake,
      ),
    );
  }

  Offset _randomBall(int widthRange, int heightRange) {
    var random = Random();
    var nextX = _getFitPosition(random.nextInt(widthRange).toDouble());
    var nextY = _getFitPosition(random.nextInt(heightRange).toDouble());
    return Offset(nextX, nextY);
  }

  double _getMaxWidth() {
    return _getFitPosition(MediaQuery.of(context).size.width);
  }

  double _getMaxHeight() {
    return _getFitPosition(MediaQuery.of(context).size.height);
  }

  double _getFitPosition(double newPosition) {
    double widthPad = newPosition % size;
    return newPosition - widthPad;
  }

  void _onKey(RawKeyEvent? event) {
    if (event.runtimeType == RawKeyDownEvent) {
      Direction newDirection = _snakeDirection;
      switch (event?.logicalKey.keyLabel) {
        case "Arrow Down":
          newDirection = Direction.down;
          break;
        case "Arrow Up":
          newDirection = Direction.up;
          break;
        case "Arrow Left":
          newDirection = Direction.left;
          break;
        case "Arrow Right":
          newDirection = Direction.right;
          break;
      }
      setState(() {
        _snakeDirection = newDirection;
      });
    }
  }

  List<Offset> _updateSnakePosition(double maxWidth, double maxHeight) {
    return List.generate(_snake.length, (index) {
      if (index > 0) {
        return _snake[index - 1];
      }
      final snakeHead = _snake[0];
      switch (_snakeDirection) {
        case Direction.left:
          return Offset(
              (snakeHead.dx - size + maxWidth) % maxWidth, snakeHead.dy);
        case Direction.right:
          return Offset((snakeHead.dx + size) % maxWidth, snakeHead.dy);
        case Direction.up:
          return Offset(
              snakeHead.dx, (snakeHead.dy - size + maxHeight) % maxHeight);
        case Direction.down:
          return Offset(snakeHead.dx, (snakeHead.dy + size) % maxHeight);
      }
    });
  }

  List<Widget> _getSnake() {
    return _snake
        .map(
          (item) => Positioned.fromRect(
            rect: Rect.fromCenter(
              center: _adjust(item),
              width: size,
              height: size,
            ),
            child: Container(
              margin: const EdgeInsets.all(1),
              color: Colors.black,
            ),
          ),
        )
        .toList();
  }

  Widget _getBall() {
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: _adjust(_ball),
        width: size,
        height: size,
      ),
      child: Container(
        margin: const EdgeInsets.all(1),
        color: Colors.orange,
      ),
    );
  }

  Offset _adjust(Offset offset) {
    return Offset(
      offset.dx + size / 2,
      offset.dy + size / 2,
    );
  }
}
