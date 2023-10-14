// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:music_player/models/songs.dart';
import 'package:music_player/palettes/color_palette.dart';
import 'package:music_player/screens/screen_navigation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  OnAudioQuery audioQuery = OnAudioQuery();

  Box<List> playListBox = getPlaylistBox();
  Box<Songs> songBox = getSongBox();

  List<SongModel> deviceSongs = [];
  List<SongModel> fetchedSongs = [];

  @override
  void initState() {
    fetchSongs();
    super.initState();
  }

  Future fetchSongs() async {
    await Permission.storage.request();
    deviceSongs = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    for (var song in deviceSongs) {
      if (song.fileExtension == "mp3") {
        fetchedSongs.add(song);
      }
    }

    for (var audio in fetchedSongs) {
      final song = Songs(
        id: audio.id.toString(),
        title: audio.displayNameWOExt,
        artist: audio.artist!,
        uri: audio.uri!,
      );
      await songBox.put(song.id, song);
    }

    // Create Favorite songs if it is not created yet

    getFavSongs();
    getRecentSongs();
    getMostPlayedSongs();
    goToHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Center(
        child: Image.asset(
          'assets/images/MusicApp (1).png',
          width: 280,
          height: 250,
        ),
      ),
    );
  }

  Future<void> goToHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ScreenNavigation()),
    );
  }

  Future getMostPlayedSongs() async {
    if (!playListBox.keys.contains('Most Played')) {
      await playListBox.put('Most Played', []);
    }
  }

  Future getRecentSongs() async {
    if (!playListBox.keys.contains('Recent')) {
      await playListBox.put('Recent', []);
    }
  }

  Future getFavSongs() async {
    if (!playListBox.keys.contains('Favourites')) {
      await playListBox.put('Favourites', []);
    }
  }
}
