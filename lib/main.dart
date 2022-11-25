import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica_player/class/themes.dart';
import 'package:musica_player/models/songs.dart';
import 'package:musica_player/screens/screen_splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SongsAdapter());
  }
  await Hive.openBox<Songs>("Songs");
  await Hive.openBox<List>("Playlist");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => ThemeProvider()),
      builder: (context, child) {
        
      final themeProvider = Provider.of<ThemeProvider>(context);


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const ScreenSplash(),
    );
      }
    );
  }
}
