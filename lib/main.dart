import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_collection/router_game.dart';

void main() {
  final game = RouterGame();
  runApp(GameWidget(game: game));
}
