import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/screen_navigation.dart';
import 'package:music_player/widgets/setting_list_tile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../palettes/color_palette.dart';

const String NOTIFICATION = 'NOTIFICATION';

class ScreenSetting extends StatefulWidget {
  const ScreenSetting({super.key});

  @override
  State<ScreenSetting> createState() => _ScreenSettingState();
}

class _ScreenSettingState extends State<ScreenSetting> {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  Future<void> setNotification(bool newValue) async {
    setState(() {
      SWITCHVALUE = newValue;
      SWITCHVALUE!
          ? audioPlayer.showNotification = true
          : audioPlayer.showNotification = false;
    });
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool(NOTIFICATION, SWITCHVALUE!);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kWhite
                ),
              ),
              const SizedBox(height: 15),
              SettingListTile(
                labeltext: 'About me',
                icon: Icons.person,
                onTap: () {
                  showAboutMeDialoge(
                    context: context,
                    screenHeight: screenHeight,
                  );
                },
              ),
              SettingListTile(
                labeltext: 'Share',
                icon: Icons.share,
                onTap: () async {
                  await Share.share(
                    'Download Música from Playstore For Free \nWith Música you can play songs in your device. Download Now On Playstore',
                  );
                },
              ),
              SettingListTile(
                labeltext: 'Notifications',
                icon: Icons.notifications,
                trailingWidget: Switch(
                  activeColor: kWhite,
                  inactiveTrackColor: bottomSheetBackgroundColor,
                  value: SWITCHVALUE!,
                  onChanged: (value) {
                    setNotification(value);
                  },
                ),
              ),
              SettingListTile(
                labeltext: 'License',
                icon: Icons.warning,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Theme(
                          data: ThemeData(
                            textTheme: const TextTheme(
                              bodyMedium: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              titleMedium: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              bodySmall: TextStyle(
                                color: kWhite,
                                fontFamily: 'Poppins',
                              ),
                              titleLarge: TextStyle(
                                fontFamily: 'Poppins',
                                color: kWhite
                              ),
                            ),
                            cardColor: kBackgroundColor,
                            appBarTheme: const AppBarTheme(
                              backgroundColor: kBackgroundColor,
                              elevation: 0,
                            ),
                          ),
                          child: const LicensePage(
                            applicationName: 'Música',
                            applicationVersion: '1.0.0',
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

showAboutMeDialoge({
  required BuildContext context,
  required double screenHeight,
}) {
  showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            height: 180,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    'About Me',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'This App is designed and developed by Nibu Krishna M.V.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
