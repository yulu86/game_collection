import 'dart:ui';

import 'package:flame/game.dart';

class BoxGame extends Game {
  late Vector2 screenSize;

  @override
  void onGameResize(Vector2 size) {
    screenSize = size;
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    var bgRect = Rect.fromLTWH(0, 0, screenSize.length, screenSize.length2);
    Paint bgPaint = Paint()..color = const Color(0xff000000);
    canvas.drawRect(bgRect, bgPaint);
  }

  @override
  void update(double dt) {
    // TODO: implement update
  }
}
