import 'package:googleapis/youtube/v3.dart';

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

  Future<Map<ResponseContent, dynamic>> search(
      {required String searchQuery,
      int maxResults = 5,
      String? pageToken,
      List<String>? type = const ['video']}) async {
    SearchListResponse searchResults = await youtubeApi.search.list(
      ['snippet'],
      q: searchQuery,
      maxResults: maxResults,
      videoCategoryId: '10',
      type: type,
      pageToken: pageToken,
    );
    List<String?> videos = [];
    videos.addAll(
        searchResults.items?.map((SearchResult result) => result.id?.videoId) ??
            []);
    return {
      ResponseContent.nextPageToken: searchResults.nextPageToken,
      ResponseContent.videoIDs: videos
    };
  }

  Future<Map<ResponseContent, dynamic>> getAllPlaylist(
      {int maxResults = 5, String? nextPageToken}) async {
    PlaylistListResponse playlists = await youtubeApi.playlists.list(
        ['snippet'],
        mine: true, maxResults: maxResults, pageToken: nextPageToken);
    List<String?> videos = [];
    videos.addAll(playlists.items?.map((Playlist result) => result.id) ?? []);
    return {
      ResponseContent.nextPageToken: playlists.nextPageToken,
      ResponseContent.videoIDs: videos
    };
  }

  Future<Map<ResponseContent, dynamic>> _getPlaylist(
      {int maxResults = 5,
      String? nextPageToken,
      required String playlistID}) async {
    PlaylistItemListResponse playlist = await youtubeApi.playlistItems.list(
        ['snippet'],
        playlistId: playlistID,
        maxResults: maxResults,
        pageToken: nextPageToken);
    List<String?> videos = [];
    for (PlaylistItem item in playlist.items ?? []) {}
    videos.addAll(playlist.items
            ?.map((PlaylistItem item) => item.snippet?.resourceId?.videoId) ??
        []);
    return {
      ResponseContent.nextPageToken: playlist.nextPageToken,
      ResponseContent.videoIDs: videos
    };
  }

  Future<Map<ResponseContent, dynamic>> getLikedVideos(
      {int maxResults = 5, String? nextPageToken}) async {
    return await _getPlaylist(
        playlistID: 'LL', maxResults: maxResults, nextPageToken: nextPageToken);
  }

  Future<Map<ResponseContent, dynamic>> getWatchLaterVideos(
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
