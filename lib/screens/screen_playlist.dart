import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica_player/functions/alert_functions.dart';
import 'package:musica_player/models/db_functions/db_function.dart';
import 'package:musica_player/models/songs.dart';
import 'package:musica_player/widgets/created_playlist.dart';

class ScreenPlaylist extends StatelessWidget {
  ScreenPlaylist({super.key});

  Box<List> playlistBox = getPlaylistBox();

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
              'Playlists',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                
              ),
            ),
            GestureDetector(
              onTap: () {
                showCreatingPlaylistDialoge(context: context);
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).backgroundColor,
                size: 27,
              ),
            )
          ],
        ),
        SizedBox(height: 10,),
        Expanded(
          child: 
          ListView(
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
                          child: Text('No Created Playlist..'),
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
                              playlistImage: 'assets/images/f0be1125eec0fe3b841cb5ed3d951bbc.jpg',
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
