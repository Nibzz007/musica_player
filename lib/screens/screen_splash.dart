// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica_player/models/db_functions/db_function.dart';
import 'package:musica_player/models/songs.dart';
import 'package:musica_player/palettes/color_palette.dart';
import 'package:musica_player/screens/screen_navigation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  OnAudioQuery audioQuery = OnAudioQuery();

  Box<List> playlistBox = getPlaylistBox();
  Box<Songs> songBox = getSongBox();

  List<SongModel> deviceSongs = [];
  List<SongModel> fetchedSongs = [];

  @override
  void initState() {
    //requestPermission();
    fetchSongs();
    super.initState();
  }

  // Future<void> requestPermission() async {
  //   await Permission.storage.request();
  // }

  Future fetchSongs() async {
    await Permission.storage.request();
    deviceSongs = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    for (var song in deviceSongs) {
      if (song.fileExtension == 'mp3') {
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
    //create a Favourite songs if it is not created
    getFavSongs();
    getRecentSongs();
    getMostPlayedSongs();
    gotoScreenHome(context);
  }

  Future getFavSongs() async {
    if (!playlistBox.keys.contains('Favourites')) {
      await playlistBox.put('Favourites', []);
    }
  }

  Future getMostPlayedSongs() async {
    if (!playlistBox.keys.contains('Most Played')) {
      await playlistBox.put('Most Played', []);
    }
  }

  Future getRecentSongs() async {
    if (!playlistBox.keys.contains('Recent')) {
      await playlistBox.put('Recent', []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Center(
        child: Image.asset(
          'assets/images/My project (2).png',
          width: 200,
        ),
      ),
    );
  }

  Future<void> gotoScreenHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const ScreenNavigation(),
      ),
    );
  }
}
