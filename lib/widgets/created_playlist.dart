import 'package:flutter/material.dart';
import '../functions/alert_functions.dart';
import '../palettes/color_palette.dart';
import '../screens/screen_created_playlist.dart';

class CreatedPlaylist extends StatelessWidget {
  const CreatedPlaylist({
    Key? key,
    required this.playlistImage,
    required this.playlistName,
    required this.playlistSongNum,
  }) : super(key: key);
  final String playlistImage;
  final String playlistName;
  final String playlistSongNum;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ScreenCreatedPlaylist(
              playlistName: playlistName,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              playlistImage,
              fit: BoxFit.cover,
              height: screenHeight * 0.21,
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  splashRadius: 1,
                  iconSize: 20,
                  onPressed: () {
                    showPlaylistDeleteAlert(
                      context: context,
                      key: playlistName,
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: kWhite,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kWhite,
                    letterSpacing: 2
                  ),
                ),
                Text(
                  playlistSongNum,
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 11,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
