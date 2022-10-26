import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:mixyr/config/config.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

class AudioHandlerAdmin extends ChangeNotifier {
  late AudioHandler _audioHandler;
  final ConcatenatingAudioSource _currentPlaylist =
      ConcatenatingAudioSource(children: []);
  void toggle() {
    _audioPlayer.playing ? _audioHandler.pause() : _audioHandler.play();
    notifyListeners();
  }

  bool isPlaying = false;
  ValueNotifier<bool> isMediaInitialised = ValueNotifier(false);
  Image _thumbnailImage = Image.asset(
    paths[Paths.defaultAlbumArt]!,
    fit: BoxFit.fill,
  );
  Color? _dominantColor;

  Color? get getDominantColor => _dominantColor;
  MediaItem? get getMediaItem => _audioHandler.mediaItem.value;
  Duration get getAudioPosition => _audioPlayer.position;
  Duration? get getAudioTotalDuration => _audioPlayer.duration;
  ValueNotifier<bool> get getIsMediaInitialised => isMediaInitialised;
  Image get getThumbnailImage => _thumbnailImage;
  Stream<MediaState> get getMediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          _audioHandler.mediaItem,
          AudioService.position,
          (mediaItem, position) => MediaState(mediaItem, position));
  AudioHandler get getAudioHandler => _audioHandler;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Future<void> calcDominantColor() async {
    _dominantColor = await dominantColor(
        img: Image.network(_audioHandler.mediaItem.value!.artUri.toString()));
  }

  List<MediaItem> _currentPlaylistMediaItems = [];
  Future<MediaItem> _getAudioUri(String audioID) async {
    var manifest =
        await YoutubeExplode().videos.streamsClient.getManifest(audioID);
    var video = await YoutubeExplode().videos.get(audioID);

    MediaItem mediaItem = MediaItem(
      id: manifest.audioOnly.first.url.toString(),
      title: video.title,
      artist: video.author,
      duration: video.duration,
      artUri: Uri.parse(video.thumbnails.highResUrl),
    );
    return mediaItem;
  }

  AudioHandlerAdmin({required AudioHandler audioHandler}) {
    _audioHandler = audioHandler;
    _audioPlayer.setAudioSource(_currentPlaylist);
    // _audioHandler.updateMediaItem(_currentPlaylistMediaItems[0]);
    _listenToPlaybackState();
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) async {
      if (_audioPlayer.duration != null &&
          playbackState.position >= _audioPlayer.duration!) {
        _audioHandler.pause();
        _audioHandler.seek(Duration.zero);
        if (_currentPlaylistMediaItems.isNotEmpty) {
          // await _audioHandler.updateMediaItem(_currentPlaylistMediaItems[0]);
        }
      }
    });
  }

  Future<void> addNewAudio(String audioId) async {
    MediaItem mItem = await _getAudioUri(audioId);
    await _audioHandler.updateMediaItem(mItem);
    await _currentPlaylist.add(AudioSource.uri(Uri.parse(mItem.id)));
    isMediaInitialised.value = true;
    try {
      _thumbnailImage = mItem.artUri?.path != null
          ? Image.network(
              mItem.artUri!.toString(),
              fit: BoxFit.cover,
            )
          : Image.asset(
              paths[Paths.defaultAlbumArt]!,
              fit: BoxFit.fill,
            );
    } catch (_) {
      _thumbnailImage = Image.asset(
        paths[Paths.defaultAlbumArt]!,
        fit: BoxFit.fill,
      );
    }
    calcDominantColor();
    notifyListeners();
  }
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayerHandler() {
    _audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }
  @override
  Future<void> updateMediaItem(MediaItem mItem) async {
    mediaItem.add(mItem);
  }

  @override
  Future<void> play() async {
    _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    _audioPlayer.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    _audioPlayer.seek(position);
  }

  @override
  Future<void> stop() async {
    _audioPlayer.stop();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.rewind,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.fastForward,
        MediaControl.skipToNext
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 2, 4],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_audioPlayer.processingState]!,
      playing: _audioPlayer.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(
    this.mediaItem,
    this.position,
  );
}
