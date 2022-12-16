import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica_player/functions/alert_functions.dart';
import 'package:musica_player/models/db_functions/db_function.dart';
import 'package:musica_player/models/songs.dart';
import 'package:musica_player/screens/screen_search.dart';
import 'package:musica_player/widgets/custom_playlist.dart';
import 'package:musica_player/widgets/song_list_tile.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({
    super.key,
  });

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  Box<Songs> songBox = getSongBox();
  Box<List> playlistBox = getPlaylistBox();

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      songBox;
      playlistBox;
    });
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Música',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ScreenSearch(
                        audioPlayer: audioPlayer,
                      );
                    },
                  ),
                );
              },
              child: Icon(
                Icons.search,
                color: Theme.of(context).backgroundColor,
                //kLightBlue,
                size: 27,
              ),
            )
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                height: screenHeight * 0.22,
                width: double.infinity,
                child: ValueListenableBuilder(
                    valueListenable: playlistBox.listenable(),
                    builder: (context, playlistBox, _) {
                      List playlistKeys = playlistBox.keys.toList();

                      playlistKeys = ['Favourites', 'Recent', 'Most Played'];
                      return (playlistKeys.isEmpty)
                          ? const Text('Nothing Found')
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: playlistKeys.length,
                              itemBuilder: (context, index) {
                                final playlistName = playlistKeys[index];

                                return CustomPlayList(
                                  playlistName: playlistName,
                                );
                              },
                            );
                    }),
              ),
              const SizedBox(height: 10,),
              const Text(
                'All Songs',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10,),
              ValueListenableBuilder(
                valueListenable: songBox.listenable(),
                builder: (BuildContext context, boxSongs, _) {
                  List<Songs> songList = songBox.values.toList().cast<Songs>();
                  return (songList.isEmpty)
                      ? const Text("No Songs Found")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SongListTile(
                              onPressed: () {
                                log(songList.length.toString());
                                showPlaylistModalSheet(
                                  context: context,
                                  screenHeight: screenHeight,
                                  song: songList[index],
                                );
                                setState(() {
                                  
                                });
                              },
                              songList: songList,
                              index: index,
                              audioPlayer: audioPlayer,
                            );
                          },
                          itemCount: songBox.length,
                        );
                },
              ),
              const SizedBox(height: 60,)
            ],
          ),
        ),
      ],
    );
  }
}
