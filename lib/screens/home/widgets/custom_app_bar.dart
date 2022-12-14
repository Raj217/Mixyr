import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';
import 'package:mixyr/screens/home/screens/search_page/search_page.dart';
import 'package:mixyr/state_handlers/audio/audio_player_handler.dart';
import 'package:mixyr/state_handlers/firebase/firebase_handler.dart';
import 'package:mixyr/state_handlers/youtube/youtube_handler.dart';
import 'package:mixyr/widgets/buttons/expanded_button.dart';
import 'package:mixyr/widgets/icons/mixyr_logo.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'search_bar.dart';
import 'package:mixyr/screens/profile/profile_screen.dart';
import 'package:mixyr/utils/basic_utilities.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      title: const MixyrLogo(),
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        ExpandedButton(
          onTap: () async {
            var search =
                await showSearch(context: context, delegate: SearchBar());
            if (search != null) {
              Provider.of<YoutubeHandler>(context, listen: false)
                  .setSearchQuery(search);
              // handler.addNewAudio(scrapeYoutubeAudioID(link: search)).then(
              //     (_) => Provider.of<YoutubeHandler>(context, listen: false)
              //         .setCurrentVideoID(handler.getCurrentVideoId));
            } else {
              Provider.of<YoutubeHandler>(context, listen: false)
                  .setSearchQuery("");
            }
          },
          icon: Icons.search,
        ),
        ExpandedButton(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: const ProfileScreen(),
                    type: PageTransitionType.bottomToTop));
          },
          child:
              Provider.of<FirebaseHandler>(context).getUserProfileImage != null
                  ? CircleAvatar(
                      foregroundImage: Provider.of<FirebaseHandler>(context)
                          .getUserProfileImage!
                          .image,
                      radius: kDefaultIconSize - 8,
                    )
                  : const Icon(
                      Icons.person,
                      size: kDefaultIconSize - 8,
                      color: kBlack,
                    ),
        )
      ],
    );
  }
}
