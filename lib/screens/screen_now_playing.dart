import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

import '../functions/alert_functions.dart';
import '../functions/favourites.dart';
import '../functions/recents.dart';
import '../models/songs.dart';
import '../palettes/color_palette.dart';
import '../widgets/custom_icon_button.dart';

class ScreenNowPlaying extends StatefulWidget {
  const ScreenNowPlaying({
    super.key,
    required this.songList,
    required this.index,
    required this.id,
    required this.audioPlayer,
  });

  final List<Audio> songList;
  final int index;
  final String id;
  final AssetsAudioPlayer audioPlayer;

  @override
  State<ScreenNowPlaying> createState() => _ScreenNowPlayingState();
}

class _ScreenNowPlayingState extends State<ScreenNowPlaying> {
  PageController? pageController;
  @override
  void initState() {
    super.initState();
  }

  bool isLoop = true;
  bool isShuffle = true;

  void shuffleButtonPressed() {
    setState(() {
      widget.audioPlayer.toggleShuffle();
      isShuffle = !isShuffle;
    });
  }

  void repeatButtonPressed() {
    if (isLoop == true) {
      widget.audioPlayer.setLoopMode(LoopMode.single);
    } else {
      widget.audioPlayer.setLoopMode(LoopMode.playlist);
    }
    setState(() {
      isLoop = !isLoop;
    });
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) {
      return element.path == fromPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return widget.audioPlayer.builderCurrent(
      builder: (context, playing) {
        final myAudio = find(widget.songList, playing.audio.assetAudioPath);
        Recents.addSongsToRecents(songId: myAudio.metas.id!);
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Now Playing',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (newValue) {
              widget.audioPlayer.playlistPlayAtIndex(newValue);

              pageController!.page!.toInt();
            },
            controller: pageController,
            //scrollDirection: Axis.vertical,
            itemCount: widget.songList.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    constraints: const BoxConstraints.expand(),
                    child: QueryArtworkWidget(
                      artworkBorder: BorderRadius.zero,
                      artworkHeight: screenHeight * 0.4,
                      artworkWidth: double.infinity,
                      id: int.parse(myAudio.metas.id!),
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Image.asset(
                        'assets/images/video.gif',
                        fit: BoxFit.cover,
                        height: screenHeight * 0.4,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                    child: Container(
                      color: Colors.black26,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: QueryArtworkWidget(
                              artworkHeight: screenHeight * 0.4,
                              artworkWidth: double.infinity,
                              id: int.parse(myAudio.metas.id!),
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Image.asset(
                                'assets/images/video.gif',
                                fit: BoxFit.cover,
                                height: screenHeight * 0.4,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.07),
                        Center(
                          child: SizedBox(
                            width: screenWidth * 0.75,
                            height: 30,
                            child: Center(
                              child: TextScroll(
                                widget.audioPlayer.getCurrentAudioTitle,
                                textAlign: TextAlign.center,
                                velocity: const Velocity(
                                  pixelsPerSecond: Offset(45, 0),
                                ),
                                mode: TextScrollMode.endless,
                                style: const TextStyle(
                                  color: kWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.audioPlayer.getCurrentAudioArtist ==
                                    '<unknown>'
                                ? 'Unknown'
                                : widget.audioPlayer.getCurrentAudioArtist,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              color: kWhite,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomIconButton(
                                icon: Icons.playlist_add,
                                onPressed: () {
                                  final song = Songs(
                                    id: myAudio.metas.id!,
                                    title: myAudio.metas.title!,
                                    artist: myAudio.metas.artist!,
                                    uri: myAudio.path,
                                  );

                                  showPlaylistModalSheet(
                                    context: context,
                                    screenHeight: screenHeight,
                                    song: song,
                                  );
                                },
                              ),
                              CustomIconButton(
                                icon: (isShuffle == true)
                                    ? Icons.shuffle
                                    : Icons.shuffle_on_outlined,
                                onPressed: () {
                                  shuffleButtonPressed();
                                },
                              ),
                              CustomIconButton(
                                icon: (isLoop == true)
                                    ? Icons.repeat
                                    : Icons.repeat_one,
                                onPressed: () {
                                  repeatButtonPressed();
                                },
                              ),
                              CustomIconButton(
                                onPressed: () {
                                  Favourites.addSongToFavourites(
                                    context: context,
                                    id: myAudio.metas.id!,
                                  );
                                  setState(() {
                                    Favourites.isThisFavourite(
                                      id: myAudio.metas.id!,
                                    );
                                  });
                                },
                                icon: Favourites.isThisFavourite(
                                    id: myAudio.metas.id!),
                              )
                            ],
                          ),
                        ),
                        widget.audioPlayer.builderRealtimePlayingInfos(
                            builder: (context, info) {
                          final duration = info.current!.audio.duration;
                          final position = info.currentPosition;

                          return ProgressBar(
                            progress: position,
                            total: duration,
                            progressBarColor: kWhite,
                            baseBarColor: Colors.grey,
                            thumbColor: kWhite,
                            bufferedBarColor: Colors.white.withOpacity(0.24),
                            barHeight: 7.0,
                            thumbRadius: 9.0,
                            onSeek: (duration) {
                              widget.audioPlayer.seek(duration);
                            },
                            timeLabelPadding: 10,
                            timeLabelTextStyle: const TextStyle(
                              color: kWhite,
                              fontSize: 15,
                            ),
                          );
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              iconSize: 45,
                              icon: playing.index == 0
                                  ? Icon(
                                      Icons.skip_previous,
                                      color: kWhiteOpacity,
                                      size: 45,
                                    )
                                  : const Icon(
                                      Icons.skip_previous,
                                      color: kWhite,
                                      size: 45,
                                    ),
                              onPressed: playing.index == 0
                                  ? () {}
                                  : () async {
                                      await widget.audioPlayer.previous();
                                      Recents.addSongsToRecents(
                                          songId: myAudio.metas.id!);
                                    },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.replay_10,
                                color: kWhite,
                              ),
                              onPressed: () {
                                widget.audioPlayer.seekBy(
                                  const Duration(seconds: -10),
                                );
                              },
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: kWhite,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: PlayerBuilder.isPlaying(
                                    player: widget.audioPlayer,
                                    builder: (context, isPlaying) {
                                      return IconButton(
                                        iconSize: 50,
                                        icon: Icon(
                                          (isPlaying == true)
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: kDarkBlue,
                                          size: 50,
                                        ),
                                        onPressed: () {
                                          widget.audioPlayer.playOrPause();
                                        },
                                      );
                                    }),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.forward_10, color: kWhite),
                              onPressed: () {
                                widget.audioPlayer.seekBy(
                                  const Duration(seconds: 10),
                                );
                              },
                            ),
                            IconButton(
                              iconSize: 45,
                              icon: playing.index == widget.songList.length - 1
                                  ? Icon(
                                      Icons.skip_next,
                                      size: 45,
                                      color: kWhiteOpacity,
                                    )
                                  : const Icon(
                                      Icons.skip_next,
                                      color: kWhite,
                                      size: 45,
                                    ),
                              onPressed:
                                  playing.index == widget.songList.length - 1
                                      ? () {}
                                      : () async {
                                          ////////////////////////////////////////////
                                          // pageController!.nextPage(
                                          //   duration: Duration(milliseconds: 550),
                                          //   curve: Curves.linear,
                                          // );

                                          ////////////////////////////////////////////
                                          await widget.audioPlayer.next();
                                          Recents.addSongsToRecents(
                                              songId: myAudio.metas.id!);
                                        },
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.09),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
