import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:mixyr/packages/youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeHandler extends ChangeNotifier {
  YoutubeAPI? youtubeApi;
  String? id;
  String? rating;
  String? pageToken;
  String query = "";
  StreamController<Video> videoStream = StreamController<Video>();
  // ---------------------------- Getter methods ----------------------------
  String? getCurrentVideoRating() {
    return rating;
  }

  String? get getCurrentId => id;
  StreamController<Video> get getVideStream => videoStream;
  String get getSearchQuery => query;

  // ---------------------------- Setter methods ----------------------------
  set setYoutubeApi(YoutubeAPI yApi) => youtubeApi = yApi;
  void setSearchQuery(String q) {
    query = q;
    notifyListeners();
  }

  Future<void> setCurrentVideoID(String i) async {
    id = i;
    rating = (await youtubeApi!.getRatingResponse(id: [id!])).items![0].rating!;
    return;
  }

  Future<void> setLiked() async {
    await youtubeApi!.setRating(id: id!, rating: 'like');
    return;
  }

  Future<void> setDisliked() async {
    await youtubeApi!.setRating(id: id!, rating: 'dislike');
    return;
  }

  Future<void> setNone() async {
    await youtubeApi!.setRating(id: id!, rating: 'none');
    return;
  }

  Future<Map<ResponseContent, dynamic>?> _getSearchList(String searchQuery,
      {String? pageToken}) async {
    try {
      return await youtubeApi!.search(
          searchQuery: searchQuery, pageToken: pageToken, maxResults: 10);
    } catch (e) {}

    return null;
  }

  Future<Video> _getVideoDetail(String videoID) async {
    Video video = await YoutubeExplode().videos.get(videoID);
    return video;
  }

  /// set needMoreVideos to true if you want to get more videos with same searchQuery
  Future<void> videoDetails(String? searchQuery,
      {bool needMoreVideos = false}) async {
    Map<ResponseContent, dynamic>? res;
    if (searchQuery != null) {
      res = await _getSearchList(searchQuery);
      if (res != null) {
        query = searchQuery;
      }
    } else {
      res = await _getSearchList(query, pageToken: pageToken);
    }
    if (res != null) {
      pageToken = res[ResponseContent.nextPageToken];
      for (int i = 0; i < (res[ResponseContent.videoIDs] ?? []).length; i++) {
        videoStream
            .add(await _getVideoDetail(res[ResponseContent.videoIDs][i]));
      }
    }
    return;
  }
}
