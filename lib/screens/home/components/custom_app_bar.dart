import 'package:flutter/material.dart';
import 'package:mixyr/config/palette.dart';
import 'package:mixyr/config/sizes.dart';
import 'package:mixyr/state_handlers/audio/audio_player_handler.dart';
import 'package:mixyr/state_handlers/firebase/firebase_handler.dart';
import 'package:mixyr/widgets/icons/mixyr_logo.dart';
import 'package:provider/provider.dart';

import 'search_bar.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Provider.of<AudioHandlerAdmin>(context, listen: false).toggle();
          },
          child: const MixyrLogo(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                var search =
                    await showSearch(context: context, delegate: SearchBar());
                if (search != null) {
                  Provider.of<AudioHandlerAdmin>(context, listen: false)
                      .addNewAudio(search);
                }
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).focusColor,
                size: kDefaultIconSize,
              ),
            ),
            SizedBox(width: responsiveWidth(10, context)),
            GestureDetector(
              onTap: () {},
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.circle,
                    size: kDefaultIconSize,
                    color: kWhite,
                  ),
                  Provider.of<FirebaseHandler>(context).getUserProfileLink !=
                          null
                      ? CircleAvatar(
                          foregroundImage: Image.network(
                            Provider.of<FirebaseHandler>(context)
                                .getUserProfileLink!,
                            fit: BoxFit.fill,
                          ).image,
                          radius: kDefaultIconSize - 8,
                        )
                      : const Icon(
                          Icons.person,
                          size: kDefaultIconSize - 8,
                          color: kBlack,
                        ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
