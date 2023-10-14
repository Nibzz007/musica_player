import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:music_player/palettes/color_palette.dart';
import '../texts/privacy.dart';
import '../texts/terms_and_conditions.dart';

class ScreenSettingTile extends StatelessWidget {
  ScreenSettingTile({
    super.key,
    required this.screenName,
  });
  final String screenName;
  String? screenContent;

  @override
  Widget build(BuildContext context) {
    screenContent =
        screenName == 'Privacy Policy' ? privacyPolicy : termsAndConditions;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kWhite,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          screenName,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Html(data: screenContent),
        ),
      ),
    );
  }
}
