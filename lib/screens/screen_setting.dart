import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musica_player/palettes/color_palette.dart';
import 'package:musica_player/screens/screen_navigation.dart';
import 'package:musica_player/screens/screen_setting_tile.dart';
import 'package:musica_player/widgets/setting_list_tile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/changeTheme.dart';

const String NOTIFICATION = 'NOTIFICATION';

class ScreenSetting extends StatefulWidget {
  const ScreenSetting({super.key});

  @override
  State<ScreenSetting> createState() => _ScreenSettingState();
}

class _ScreenSettingState extends State<ScreenSetting> {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  void initState() {
    super.initState();
  }

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
                labeltext: 'Light and Dark theme',
                icon: Icons.dark_mode,
                onTap: () {
                 
                },
                trailingWidget: ChangeThemeButtonWidget(),
              ),
              SettingListTile(
                labeltext: 'Notifications',
                icon: Icons.notifications,
                trailingWidget: Switch(
                  inactiveThumbColor: kLightBlue,
                  value: SWITCHVALUE!,
                  onChanged: (newValue) async {
                    setNotification(newValue);
                  },
                ),
              ),
              SettingListTile(
                labeltext: 'Privacy Policy',
                icon: Icons.security,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ScreenSettingTile(screenName: 'Privacy Policy');
                    }),
                  );
                },
              ),
              SettingListTile(
                labeltext: 'Terms and Conditions',
                icon: Icons.security,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ScreenSettingTile(
                          screenName: 'Terms and Conditions');
                    }),
                  );
                },
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
                              bodyText2: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              subtitle1: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              caption: TextStyle(
                                color: kLightBlue,
                                fontFamily: 'Poppins',
                              ),
                              headline6: TextStyle(
                                fontFamily: 'Poppins',
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
        ),
        Column(
          children: const [
            Text(
              'Version',
              style: TextStyle(
                color: kLightBlue,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                '1.0.0',
                style: TextStyle(
                  color: kLightBlue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

showAboutMeDialoge(
    {required BuildContext context, required double screenHeight}) {
  showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: const [
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
