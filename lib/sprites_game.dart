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
}
