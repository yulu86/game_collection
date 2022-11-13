import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

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

class SpritesGame extends FlameGame with TapDetector {
  final pauseOverlayIdentifier = 'PauseMenu';

  @override
  Future<void>? onLoad() async {
    await add(MyCrate());
  }

  // 透明背景色，可以看到GameWidget背后的小组件
  @override
  Color backgroundColor() => const Color(0xffffffff);

  @override
  void onTap() {
    if (overlays.isActive('PauseMenu')) {
      overlays.remove('PauseMenu');
      resumeEngine();
    } else {
      overlays.add('PauseMenu');
      pauseEngine();
    }
  }
}

class MyGameWidget extends StatelessWidget {
  MyGameWidget({Key? key}) : super(key: key);

  final SpritesGame game = SpritesGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      overlayBuilderMap: {
        'PauseMenu': (BuildContext context, SpritesGame game) {
          return Center(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.orange,
              child: const Center(
                child: Text('Paused'),
              ),
            ),
          );
        },
      },
      initialActiveOverlays: const ['PauseMenu'],
    );
  }
}
