import 'dart:ui';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

class BoxGame extends FlameGame with HasTappableComponents {
  late Vector2 screenSize;
  bool hasWon = false;

  @override
  void onGameResize(Vector2 canvasSize) {
    screenSize = canvasSize;
    super.onGameResize(canvasSize);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    hasWon = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 屏幕宽度和高度
    double screenWidth = screenSize.x;
    double screenHeight = screenSize.y;

    // 绘制黑色背景
    var bgRect = Rect.fromLTWH(0, 0, screenWidth, screenHeight);
    Paint bgPaint = Paint()..color = const Color(0xff000000);
    canvas.drawRect(bgRect, bgPaint);

    // 绘制白色方块
    double screenCenterX = screenWidth / 2;
    double screenCenterY = screenHeight / 2;
    double size = 150;
    Rect boxRect = Rect.fromLTWH(
      screenCenterX - size / 2,
      screenCenterY - size / 2,
      size,
      size,
    );
    Paint boxPaint = Paint();
    if (hasWon) {
      boxPaint.color = const Color(0xff00ff00);
    } else {
      boxPaint.color = const Color(0xffffffff);
    }
    canvas.drawRect(boxRect, boxPaint);
  }

  @override
  void update(double dt) {
    // TODO: implement update
  }
}
