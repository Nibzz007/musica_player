import 'package:flutter/material.dart';
import 'package:musica_player/models/db_functions/db_function.dart';
import 'package:musica_player/models/songs.dart';
import 'package:musica_player/palettes/color_palette.dart';
import 'package:musica_player/screens/screen_created_playlist.dart';
import 'package:musica_player/screens/screen_favourite.dart';

class CustomPlayList extends StatelessWidget {
  const CustomPlayList({
    Key? key,
    required this.playlistName,
  }) : super(key: key);
  
  final String playlistName;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final List<Songs> songList =
        getPlaylistBox().get(playlistName)!.toList().cast<Songs>();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              if (playlistName == 'Favourites') {
                return ScreenFavourites(
                  playlistName: "Favourites",
                );
              }
              if (playlistName == 'Recent') {
                return ScreenFavourites(
                  playlistName: "Recent",
                );
              }
              if (playlistName == 'Most Played') {
                return ScreenFavourites(
                  playlistName: "Most Played",
                );
              }
              return ScreenCreatedPlaylist(
                playlistName: playlistName,
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: kBlue
            ),
            height: 150,
            margin: const EdgeInsets.only(right: 10),
            width: screenWidth * 0.35,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      playlistName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                    songList.length == 1
                        ? Text(
                            ' ${songList.length} Song',
                            style:  TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 13,
                            ),
                          )
                        : Text(
                            ' ${songList.length} Songs',
                            style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 13,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
