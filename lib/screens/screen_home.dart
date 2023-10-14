import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:music_player/models/songs.dart';
import 'package:music_player/palettes/color_palette.dart';
import 'package:music_player/screens/screen_search.dart';
import '../functions/alert_functions.dart';
import '../widgets/custom_playlist.dart';
import '../widgets/song_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box<Songs> songBox = getSongBox();
  Box<List> playListBox = getPlaylistBox();

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  void initState() {
    setState(() {
      songBox;
      playListBox;
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
            const Text(
              'MusicApp',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: kWhite,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ScreenSearch(audioPlayer: audioPlayer),
                  ),
                );
              },
              child: const Icon(
                Icons.search,
                size: 27,
                color: kWhite,
              ),
            ),
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
                  valueListenable: playListBox.listenable(),
                  builder: (context, playlistBox, _) {
                    List playListKeys = playListBox.keys.toList();
                    playListKeys = ['Favourites', 'Recent', 'Most Played'];
                    return (playListKeys.isEmpty)
                        ? const Text('Nothing Found')
                        : ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: playListKeys.length,
                            itemBuilder: (context, index) {
                              final playlistName = playListKeys[index];

                              return CustomPlayList(
                                playlistName: playlistName,
                              );
                            },
                          );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'All Songs',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: kWhite,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ValueListenableBuilder(
                valueListenable: songBox.listenable(),
                builder: (context, boxSongs, _) {
                  List<Songs> songList = songBox.values.toList().cast<Songs>();
                  return (songList.isEmpty)
                      ? const Center(
                          child: Text(
                            "No Songs Found",
                            style: TextStyle(color: kWhite),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SongListTile(
                              onPressed: () {
                                showPlaylistModalSheet(
                                  context: context,
                                  screenHeight: screenHeight,
                                  song: songList[index],
                                );
                                setState(() {});
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
            ],
          ),
        ),
      ],
    );
  }
}
