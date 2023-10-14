import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/functions/db_functions.dart';
import 'package:music_player/functions/playlist_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../models/songs.dart';
import '../palettes/color_palette.dart';
import '../widgets/mini_player_widget.dart';
import '../widgets/search_widget.dart';

showMiniPlayer({
  required BuildContext context,
  required int index,
  required List<Songs> songList,
  required AssetsAudioPlayer audioPlayer,
}) {
  return showBottomSheet(
      context: context,
      builder: (ctx) {
        return MiniPlayer(
          songList: songList,
          index: index,
          audioPlayer: audioPlayer,
        );
      });
}

showPlaylistModalSheet({
  required BuildContext context,
  required double screenHeight,
  required Songs song,
}) {
  Box<List> playListBox = getPlaylistBox();
  return showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return Container(
        decoration: BoxDecoration(
          color: bottomSheetBackgroundColor,
        ),
        height: screenHeight * 0.55,
        child: Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showCreatingPlaylistDialoge(context: ctx);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: kWhite,
              ),
              child: const Text(
                'Create Playlist',
                style: TextStyle(color: kBlack),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: playListBox.listenable(),
                builder: (context, boxSongList, _) {
                  final List<dynamic> keys = playListBox.keys.toList();

                  keys.removeWhere((key) => key == 'Favourites');
                  keys.removeWhere((key) => key == 'Recent');
                  keys.removeWhere((key) => key == 'Most Played');

                  return Expanded(
                    child: (keys.isEmpty)
                        ? const Center(
                            child: Text(
                              "No Playlist Found",
                              style: TextStyle(color: kWhite),
                            ),
                          )
                        : ListView.builder(
                            itemCount: keys.length,
                            itemBuilder: (ctx, index) {
                              final String playlistKey = keys[index];

                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  onTap: () async {
                                    UserPlaylist.addSongToPlaylist(
                                        context: context,
                                        songId: song.id,
                                        playlistName: playlistKey);

                                    Navigator.pop(context);
                                  },
                                  leading: Image.asset(
                                    'assets/images/music logo design.png',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    playlistKey,
                                    style: const TextStyle(
                                      color: kWhite,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                })
          ],
        ),
      );
    },
  );
}

showCreatingPlaylistDialoge({required BuildContext context}) {
  TextEditingController textEditingController = TextEditingController();
  Box<List> playlistBox = getPlaylistBox();

  Future<void> createNewplaylist() async {
    List<Songs> songList = [];
    final String playlistName = textEditingController.text.trim();
    if (playlistName.isEmpty) {
      return;
    }
    await playlistBox.put(playlistName, songList);
  }

  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final formKey = GlobalKey<FormState>();
        return Form(
          key: formKey,
          child: AlertDialog(
            backgroundColor: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Create playlist',
              style: TextStyle(
                color: kDarkBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SearchField(
              textController: textEditingController,
              hintText: 'Playlist Name',
              icon: Icons.playlist_add,
              validator: (value) {
                final keys = getPlaylistBox().keys.toList();
                if (value == null || value.isEmpty) {
                  return 'Playlist name cannot be empty';
                }
                if (keys.contains(value)) {
                  return '$value Already exist in playlist';
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: kDarkBlue,
                    fontSize: 15,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await createNewplaylist();
                    Navigator.pop(ctx);
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: kDarkBlue,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

showPlaylistDeleteAlert({required BuildContext context, required String key}) {
  final playlistBox = getPlaylistBox();
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Playlist',
            style: TextStyle(color: kDarkBlue),
          ),
          content: const Text(
            'Are you sure ?',
            style: TextStyle(color: kDarkBlue),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'No',
                style: TextStyle(
                  color: kDarkBlue,
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await playlistBox.delete(key);
                Navigator.pop(ctx);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: kDarkBlue,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      });
}

showSongModalSheet({
  required BuildContext context,
  required double screenHeight,
  required String playlistKey,
}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) {
      final songBox = getSongBox();
      return Container(
        decoration: BoxDecoration(
          color: bottomSheetBackgroundColor,
        ),
        height: screenHeight * 0.55,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Add Songs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kWhite,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: songBox.listenable(),
                builder:
                    (BuildContext context, Box<Songs> boxSongs, Widget? child) {
                  return ListView.builder(
                    itemCount: boxSongs.values.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      final List<Songs> songsList = boxSongs.values.toList();
                      final Songs song = songsList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: ListTile(
                          onTap: () {
                            UserPlaylist.addSongToPlaylist(
                              context: context,
                              songId: song.id,
                              playlistName: playlistKey,
                            );

                            Navigator.pop(context);
                          },
                          leading: QueryArtworkWidget(
                            id: int.parse(song.id),
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(10),
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/musicHome.png',
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          title: Text(
                            song.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: kWhite
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
