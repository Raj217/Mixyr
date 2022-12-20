import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis/searchconsole/v1.dart';

enum ResponseContent { nextPageToken, videoIDs, playlistIDs }

class YoutubeAPI {
  final YouTubeApi youtubeApi;
  YoutubeAPI({required this.youtubeApi});

  Future<void> getRandomVideoByCategory(
      {String videoCategory = '10', // 10 for music
      List<String> id = const []}) async {
    var test = await youtubeApi.videos.list(['snippet'], id: id);
    for (Video item in test.items ?? []) {
      if (item.snippet?.categoryId == '10') {
        print(item.id);
      }
    }
  }

  Future<SearchListResponse> search(
      {required String searchQuery,
      int maxResults = 5,
      String? pageToken,
      List<String>? type = const ['video']}) async {
    PlaylistItemListResponse res = await getWatchLaterVideos();
    print(res.items?.map((PlaylistItem item) => item.snippet?.title));
    return await youtubeApi.search.list(
      ['snippet'],
      q: searchQuery,
      maxResults: maxResults,
      type: type,
      pageToken: pageToken,
    );
    // print(searchResults);
    // List<String?> videos = [];
    // videos.addAll(
    //     searchResults.items?.map((SearchResult result) => result.id?.videoId) ??
    //         []);
    // return {
    //   ResponseContent.nextPageToken: searchResults.nextPageToken,
    //   ResponseContent.videoIDs: videos
    // };
  }

  Future<VideoListResponse> getVideoDetails(String videoId) async {
    return await youtubeApi.videos.list(['contentDetails'], id: [videoId]);
  }

  Future<PlaylistListResponse> getAllPlaylist(
      {int maxResults = 5, String? nextPageToken}) async {
    PlaylistListResponse playlists = await youtubeApi.playlists.list(
        ['snippet'],
        mine: true, maxResults: maxResults, pageToken: nextPageToken);
    return playlists;
  }

  Future<PlaylistItemListResponse> _getPlaylist(
      {int maxResults = 5,
      String? nextPageToken,
      required String playlistID}) async {
    PlaylistItemListResponse playlist = await youtubeApi.playlistItems.list(
        ['snippet'],
        playlistId: playlistID,
        maxResults: maxResults,
        pageToken: nextPageToken);
    return playlist;
  }

  Future<PlaylistItemListResponse> getLikedVideos(
      {int maxResults = 5, String? nextPageToken}) async {
    return await _getPlaylist(
        playlistID: 'LL', maxResults: maxResults, nextPageToken: nextPageToken);
  }

  Future<PlaylistItemListResponse> getWatchHistoryVideos(
      {int maxResults = 5, String? nextPageToken}) async {
    return await _getPlaylist(
        playlistID: 'HL', maxResults: maxResults, nextPageToken: nextPageToken);
  }

  Future<PlaylistItemListResponse> getWatchLaterVideos(
      {int maxResults = 5, String? nextPageToken}) async {
    return await _getPlaylist(
        playlistID: 'WL', maxResults: maxResults, nextPageToken: nextPageToken);
  }

  Future<void> setRating({required String id, required String rating}) async {
    await youtubeApi.videos.rate(id, rating);
    return;
  }

  Future<VideoGetRatingResponse> getRatingResponse(
      {required List<String> id}) async {
    return await youtubeApi.videos.getRating(id);
  }
}
