import 'package:flutter/material.dart';
import 'package:music_player/palettes/color_palette.dart';
import 'package:music_player/screens/screen_home.dart';
import 'package:music_player/screens/screen_playlist.dart';
import 'package:music_player/screens/screen_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? SWITCHVALUE;

class ScreenNavigation extends StatefulWidget {
  const ScreenNavigation({super.key});

  @override
  State<ScreenNavigation> createState() => _ScreenNavigationState();
}

class _ScreenNavigationState extends State<ScreenNavigation> {
  @override
  void initState() {
    checkNotification();
    super.initState();
  }

  Future<void> checkNotification() async {
    final SharedPreferences sharedPreds = await SharedPreferences.getInstance();
    SWITCHVALUE = sharedPreds.getBool(NOTIFICATION);
    SWITCHVALUE = SWITCHVALUE ??= true;
  }

  final bottomNavBar = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.queue_music), label: 'Playlist'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  final List<Widget> screens = <Widget>[
    const HomeScreen(),
    ScreenPlaylist(),
    const ScreenSetting()
  ];

  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
          child: screens[selectIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavBar,
        onTap: (value) {
          setState(() {
            selectIndex = value;
          });
        },
        currentIndex: selectIndex,
        elevation: 0,
        iconSize: 30,
        selectedItemColor: kWhite,
        backgroundColor: bottomSheetBackgroundColor,
        unselectedItemColor: kWhiteOpacity,
      ),
    );
  }
}
