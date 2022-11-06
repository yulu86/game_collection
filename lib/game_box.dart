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
    // TODO: implement render
  }

  @override
  void update(double dt) {
    // TODO: implement update
  }
}
