import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../functions/alert_functions.dart';
import '../functions/db_functions.dart';
import '../functions/playlist_functions.dart';
import '../models/songs.dart';
import '../palettes/color_palette.dart';
import '../widgets/search_widget.dart';
import '../widgets/song_list_tile.dart';

class ScreenCreatedPlaylist extends StatefulWidget {
  const ScreenCreatedPlaylist({
    super.key,
    required this.playlistName,
  });

  final String playlistName;

  @override
  State<ScreenCreatedPlaylist> createState() => _ScreenCreatedPlaylistState();
}

class _ScreenCreatedPlaylistState extends State<ScreenCreatedPlaylist> {
  String? newPlaylistName;
  @override
  void initState() {
    newPlaylistName = widget.playlistName;
    super.initState();
  }

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  Box<Songs> songBox = getSongBox();
  Box<List> playlistBox = getPlaylistBox();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
          newPlaylistName!,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final List<Songs> playlistSongs =
                  playlistBox.get(newPlaylistName)!.toList().cast<Songs>();
              showEditingPlaylistDialoge(
                context: context,
                playlistName: newPlaylistName!,
                playlistSongs: playlistSongs,
              );
            },
            icon: const Icon(
              Icons.edit,
              color: kWhite,
            ),
          ),
          IconButton(
            onPressed: () {
              showSongModalSheet(
                context: context,
                screenHeight: screenHeight,
                playlistKey: newPlaylistName!,
              );
            },
            icon: const Icon(
              Icons.add,
              size: 27,
              color: kWhite,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
        child: ValueListenableBuilder<Box<List<dynamic>>>(
          valueListenable: playlistBox.listenable(),
          builder: (context, boxSongList, _) {
            final List<Songs> songList =
                boxSongList.get(newPlaylistName)!.cast<Songs>();

            if (songList.isEmpty) {
              return const Center(
                child: Text(
                  'No Songs Found',
                  style: TextStyle(color: kWhite),
                ),
              );
            }
            return ListView.builder(
              itemCount: songList.length,
              itemBuilder: (ctx, index) {
                return SongListTile(
                  icon: Icons.delete_outline_rounded,
                  onPressed: () {
                    UserPlaylist.deleteFromPlaylist(
                      context: context,
                      songId: songList[index].id,
                      playlistName: newPlaylistName!,
                    );
                  },
                  songList: songList,
                  index: index,
                  audioPlayer: audioPlayer,
                );
              },
            );
          },
        ),
      ),
    );
  }

  showEditingPlaylistDialoge({
    required BuildContext context,
    required String playlistName,
    required List<Songs> playlistSongs,
  }) {
    final TextEditingController textController =
        TextEditingController(text: playlistName);
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final formKey = GlobalKey<FormState>();
          return Form(
            key: formKey,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: kWhite,
              title: const Text(
                'Edit playlist',
                style: TextStyle(
                  color: kDarkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SearchField(
                textController: textController,
                hintText: 'Playlist Name',
                icon: Icons.playlist_add,
                validator: (value) {
                  final keys = getPlaylistBox().keys.toList();
                  if (value == null || value.isEmpty) {
                    return 'Field is empty';
                  }
                  if (keys.contains(value)) {
                    return '$value already exist in playlist';
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
                    style: TextStyle(color: kDarkBlue, fontSize: 15),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final playlistBox = getPlaylistBox();
                      setState(() {
                        newPlaylistName = textController.text.trim();
                      });
                      await playlistBox.put(newPlaylistName, playlistSongs);
                      playlistBox.delete(playlistName);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: kDarkBlue, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
