import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/palettes/color_palette.dart';
import '../functions/alert_functions.dart';
import '../functions/db_functions.dart';
import '../models/songs.dart';
import '../widgets/search_widget.dart';
import '../widgets/song_list_tile.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key, required this.audioPlayer});
  final AssetsAudioPlayer audioPlayer;

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  final TextEditingController _searchController = TextEditingController();
  Box<Songs> songBox = getSongBox();
  List<Songs>? dbSongs;
  List<Songs>? searchedSongs;

  @override
  void initState() {
    super.initState();
    dbSongs = songBox.values.toList().cast<Songs>();
    searchedSongs = List<Songs>.from(dbSongs!).toList().cast<Songs>();
  }

  searchSongfomDb(String searchSong) {
    setState(() {
      searchedSongs = dbSongs!
          .where((song) =>
              song.title.toLowerCase().contains(searchSong.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20,
        ),
        child: Column(
          children: [
            SearchField(
              validator: (value) {
                return null;
              },
              textController: _searchController,
              hintText: 'Search for songs',
              icon: Icons.search,
              onChanged: (value) {
                searchSongfomDb(value);
              },
            ),
            Expanded(
              child: (searchedSongs!.isEmpty)
                  ? const Center(
                      child: Text('No Songs Found'),
                    )
                  : ListView.builder(
                      itemCount: searchedSongs!.length,
                      itemBuilder: (ctx, index) {
                        return SongListTile(
                          onPressed: () {
                            showPlaylistModalSheet(
                                context: context,
                                screenHeight: screenHeight,
                                song: dbSongs![index]);
                          },
                          songList: searchedSongs!,
                          index: index,
                          audioPlayer: widget.audioPlayer,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
