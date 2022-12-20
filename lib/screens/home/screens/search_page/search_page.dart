import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:mixyr/state_handlers/youtube/youtube_handler.dart';
import 'package:provider/provider.dart';
import 'widgets/search_card.dart';

class SearchPage extends StatefulWidget {
  final String query;
  final ScrollController scrollController;
  const SearchPage(
      {Key? key, required this.query, required this.scrollController})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchCard> test = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      search();
      Provider.of<YoutubeHandler>(context, listen: false)
          .getVideStream
          .stream
          .listen((videoData) {
        setState(() {
          test.add(SearchCard(video: videoData));
        });
      });
    });
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.atEdge &&
          widget.scrollController.position.pixels != 0) {
        search(getMoreContent: true);
      }
    });
  }

  void search({bool getMoreContent = false}) {
    if (getMoreContent) {
      Provider.of<YoutubeHandler>(context, listen: false)
          .videoDetails(needMoreVideos: true);
    } else {
      Provider.of<YoutubeHandler>(context, listen: false)
          .videoDetails(searchQuery: widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (test.isEmpty) {
      return SliverList(
          delegate: SliverChildListDelegate([
        const Center(
          child: CircularProgressIndicator(),
        )
      ]));
    } else {
      return SliverList(
        delegate: SliverChildListDelegate([
          Column(
            children: test,
          )
        ]),
      );
    }
  }
}
