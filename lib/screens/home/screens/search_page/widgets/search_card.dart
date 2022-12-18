import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchCard extends StatelessWidget {
  final Video video;
  final double heightWRTScreenWidth;
  const SearchCard(
      {Key? key, this.heightWRTScreenWidth = 0.2, required this.video})
      : assert(heightWRTScreenWidth < 1,
            "heightWRTScreenWidth cannot be more than 1"),
        super(key: key);

  String formatTime(int val) {
    if (val < 10) {
      return "0$val";
    }
    return "$val";
  }

  @override
  Widget build(BuildContext context) {
    String duration = "";
    int hours, mins, secs;
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.width * heightWRTScreenWidth;
    if (video.duration != null) {
      hours = video.duration!.inHours;
      mins = video.duration!.inMinutes - hours * 60;
      secs = video.duration!.inSeconds - hours * 60 * 60 - mins * 60;
      duration = formatTime(secs);
      if (mins != 0) {
        duration = "${formatTime(mins)}:$duration";
      }
      if (hours != 0) {
        duration = "${formatTime(hours)}:$duration";
      }
    }
    return SizedBox(
      width: screenSize.width * (1 - heightWRTScreenWidth / 4),
      child: Row(
        children: [
          SizedBox(
            height: height,
            width: height * 16 / 9, // Youtube thumbnail ratio
            child: Image.network(
              video.thumbnails.standardResUrl,
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: screenSize.width - height * 21 / 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: screenSize.width - height * 32 / 9,
                        child: Text(
                          video.author,
                          style: const TextStyle(
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
