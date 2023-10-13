import 'package:hive_flutter/hive_flutter.dart';
import '../models/songs.dart';
import 'db_functions.dart';
import 'most_played.dart';

class Recents {
  static final Box<Songs> songBox = getSongBox();
  static final Box<List> playlistBox = getPlaylistBox();

  static addSongsToRecents({required String songId}) async {
    final List<Songs> dbSongs = songBox.values.toList().cast<Songs>();
    final List<Songs> recentSongList =
        playlistBox.get('Recent')!.toList().cast<Songs>();

    final Songs recentSong =
        dbSongs.firstWhere((song) => song.id.contains(songId));

    ///////////////---------For Most Played----------///////////////////////////

    int count = recentSong.count;
    recentSong.count = count + 1;
    MostPlayed.addSongToPlaylist(songId);

    if (recentSongList.length >= 10) {
      recentSongList.removeLast();
    }
    if (recentSongList.where((song) => song.id == recentSong.id).isEmpty) {
      recentSongList.insert(0, recentSong);
      await playlistBox.put('Recent', recentSongList);
    } else {
      recentSongList.removeWhere((song) => song.id == recentSong.id);
      recentSongList.insert(0, recentSong);
      await playlistBox.put('Recent', recentSongList);
    }
  }
}
