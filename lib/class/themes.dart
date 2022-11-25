import 'package:flutter/material.dart';

class MyThemes{
  static final darkTheme = ThemeData(
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    primaryColor: Colors.black ,
    iconTheme: IconThemeData(color: Colors.white)

    
  );
  static final lightTheme = ThemeData(
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
    primaryColor: Colors.white,
    iconTheme: IconThemeData(color: Color.fromARGB(255, 11, 7, 7))

    
  );
}

class ThemeProvider extends ChangeNotifier{
    ThemeMode themeMode = ThemeMode.dark;

    bool get isDarkMode => themeMode == ThemeMode.light;

    void toggleTheme(bool isOn){
       themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
       notifyListeners(); 
    }
}