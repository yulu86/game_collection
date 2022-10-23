import 'package:flutter/material.dart';

class Rocket extends StatelessWidget {
  const Rocket({
    Key? key,
    required this.x,
    required this.y,
    required this.color,
  }) : super(key: key);

  final double x;
  final double y;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, y),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 20,
          color: color,
        ),
      ),
    );
  }
}
