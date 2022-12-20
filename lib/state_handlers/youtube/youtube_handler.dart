import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/youtube/v3.dart' as yt;
import 'package:mixyr/packages/youtube_api/youtube_api.dart';
import 'package:mixyr/utils/basic_utilities.dart';
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

  Future<yt.SearchListResponse?> _getSearchList(String searchQuery,
      {String? pageToken}) async {
    try {
      // print(await YoutubeExplode().search(searchQuery));
      return await youtubeApi!.search(
          //TODO: Improve
          searchQuery: searchQuery,
          pageToken: pageToken,
          maxResults: 10);
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<Video> _getVideoDetail(yt.SearchResult res) async {
    print(res.snippet?.title ?? "");
    // Duration dur = parseDuration(
    //     (await youtubeApi?.getVideoDetails(res.id?.videoId ?? ""))
    //             ?.items?[0]
    //             .contentDetails
    //             ?.duration ??
    //         "");

    Video video = Video(
        VideoId(res.id?.videoId ?? ""),
        res.snippet?.title ?? "",
        res.snippet?.channelTitle ?? "",
        ChannelId(res.snippet?.channelId ?? ""),
        null,
        null,
        res.snippet?.publishedAt,
        res.snippet?.description ?? "",
        Duration.zero,
        ThumbnailSet(res.id?.videoId ?? ""),
        null,
        const Engagement(0, 0, 0), // For optimisation
        res.snippet?.liveBroadcastContent == 'live');
    return video;
  }

  /// set needMoreVideos to true if you want to get more videos with same searchQuery
  Future<void> videoDetails(
      {String? searchQuery, bool needMoreVideos = false}) async {
    yt.SearchListResponse? res;
    if (searchQuery != null) {
      res = await _getSearchList(searchQuery);
      if (res != null) {
        query = searchQuery;
      }
    } else {
      res = await _getSearchList(query, pageToken: pageToken);
    }
    if (res != null) {
      pageToken = res.nextPageToken;
      for (int i = 0; i < (res.items ?? []).length; i++) {
        videoStream
            .add(await _getVideoDetail(res.items?[i] as yt.SearchResult));
      }
    }
    return;
  }
}
