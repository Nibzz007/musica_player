import 'package:flutter/material.dart';
import 'package:musica_player/class/themes.dart';
import 'package:musica_player/palettes/color_palette.dart';
import 'package:provider/provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(
      inactiveThumbColor: kLightBlue,
      value: themeProvider.isDarkMode,
      onChanged: ((value) {
        final provider = Provider.of<ThemeProvider>(context,listen: false);
        provider.toggleTheme(value);
      }),
    );
  }
}
