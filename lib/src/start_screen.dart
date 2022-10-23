import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    Key? key,
    required this.isShow,
  }) : super(key: key);

  final bool isShow;

  @override
  Widget build(BuildContext context) {
    if (isShow) {
      return Container();
    }
    return Container(
      alignment: Alignment(0, -0.2),
      child: Text(
        '开始游戏',
        style: TextStyle(
          fontSize: 32,
          color: Colors.grey,
        ),
      ),
    );
  }
}
