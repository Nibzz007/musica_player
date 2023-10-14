import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/palettes/color_palette.dart';
import '../functions/alert_functions.dart';
import '../functions/db_functions.dart';
import '../models/songs.dart';
import '../widgets/created_playlist.dart';

class ScreenPlaylist extends StatelessWidget {
  ScreenPlaylist({super.key});

  Box<List> playlistBox = getPlaylistBox();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Playlists',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: kWhite,
              ),
            ),
            GestureDetector(
              onTap: () {
                showCreatingPlaylistDialoge(context: context);
              },
              child: const Icon(
                Icons.add,
                color: kWhite,
                size: 27,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 15),
              ValueListenableBuilder(
                valueListenable: playlistBox.listenable(),
                builder: (context, value, child) {
                  List keys = playlistBox.keys.toList();
                  keys.removeWhere((key) => key == 'Favourites');
                  keys.removeWhere((key) => key == 'Recent');
                  keys.removeWhere((key) => key == 'Most Played');
                  return (keys.isEmpty)
                      ? const Center(
                          child: Text(
                            'No Created Playlist..',
                            style: TextStyle(color: kWhite),
                          ),
                        )
                      : GridView.builder(
                          itemCount: keys.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 1.25,
                          ),
                          itemBuilder: (context, index) {
                            final String playlistName = keys[index];

                            final List<Songs> songList = playlistBox
                                .get(playlistName)!
                                .toList()
                                .cast<Songs>();

                            final int songListlength = songList.length;

                            return CreatedPlaylist(
                              playlistImage:
                                  'assets/images/f0be1125eec0fe3b841cb5ed3d951bbc.jpg',
                              playlistName: playlistName,
                              playlistSongNum: '$songListlength Songs',
                            );
                          },
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
