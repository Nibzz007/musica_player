import 'package:flutter/material.dart';
import 'package:musica_player/screens/screen_home.dart';
import 'package:musica_player/screens/screen_playlist.dart';
import 'package:musica_player/screens/screen_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? SWITCHVALUE;

class ScreenNavigation extends StatefulWidget {
  const ScreenNavigation({super.key});

  @override
  State<ScreenNavigation> createState() => ScreenNavigationState();
}

class ScreenNavigationState extends State<ScreenNavigation> {
  @override
  void initState() {
    checkNotification();
    super.initState();
  }

  Future<void> checkNotification() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    SWITCHVALUE = sharedPrefs.getBool(NOTIFICATION);
    SWITCHVALUE = SWITCHVALUE ??= true;
  }

  final _bottomNavBar = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.queue_music), label: 'Playlist'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  final List<Widget> _screens = <Widget>[
    const ScreenHome(),
    ScreenPlaylist(),
    const ScreenSetting(),
    
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        currentIndex: _selectedIndex,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        iconSize: 30,
        selectedItemColor:  Theme.of(context).backgroundColor,
        //const Color(0xFFBBE1FA),
        unselectedItemColor: const Color.fromARGB(255, 109, 164, 200),
        items: _bottomNavBar,
      ),
    );
  }
}
