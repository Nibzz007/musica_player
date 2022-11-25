import 'package:flutter/material.dart';
import 'package:musica_player/palettes/color_palette.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {},
      onTap: onPressed,
      child: Icon(
        icon,
        color: kWhite,
        size: 30,
      ),
    );
  }
}
