import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class MyCrate extends SpriteComponent {
  MyCrate() : super(size: Vector2.all(80), anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('crate.png');
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = size / 2;
  }
}

class SpritesGame extends FlameGame {
  @override
  Future<void>? onLoad() async {
    await add(MyCrate());
  }

  // 透明背景色，可以看到GameWidget背后的小组件
  @override
  Color backgroundColor() => const Color(0x00000000);
}
