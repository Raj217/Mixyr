import 'package:flutter/cupertino.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:mixyr/packages/youtube_api/youtube_api.dart';

class YoutubeHandler extends ChangeNotifier {
  YoutubeAPI? youtubeApi;
  String? id;
  // ---------------------------- Getter methods ----------------------------
  Future<String> getCurrentVideoRating() async {
    return (await youtubeApi!.getRatingResponse(id: [id!])).items![0].rating!;
  }

  // ---------------------------- Setter methods ----------------------------
  set setYoutubeApi(YoutubeAPI yApi) => youtubeApi = yApi;
  set setCurrentVideoID(String i) => id = i;
  Future<void> setLiked() async {
    return youtubeApi!.setRating(id: id!, rating: 'like');
  }

  Future<void> setDisliked() async {
    return youtubeApi!.setRating(id: id!, rating: 'dislike');
  }

  Future<void> setNone() async {
    return youtubeApi!.setRating(id: id!, rating: 'none');
  }
}
