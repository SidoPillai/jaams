import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jaamsapp/StoryView.dart';
import 'package:story/story_page_view/story_page_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'StoryController.dart';
import 'Utils.dart';
import 'main.dart';


class StoryWidget extends StatelessWidget {

  final AsyncSnapshot<List<StoryMap>> snapshot;
  StoryWidget({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data!.length,
        itemBuilder: (BuildContext context, int index) => Container(
          height: 50,
          child: Center(
            child: InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return StoryPage(snapshot: snapshot, index: index);
                    },
                  ),
                )
              },
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshot.data![index].thumbnailUrl),
                radius: 32,
              ),
            ),
          ),
          margin: EdgeInsets.all(10),
        ),
      ),
    );
  }
}

class UserModel {
  UserModel(this.stories, this.userName, this.imageUrl);

  final List<StoryModel> stories;
  final String userName;
  final String imageUrl;
}

class StoryModel {
  StoryModel(this.imageUrl);

  final String imageUrl;
}

class WebViewController extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    return WebView(initialUrl: "https://storymaps.arcgis.com");
  }
}

class StoryPage extends StatelessWidget {
  final AsyncSnapshot<List<StoryMap>> snapshot;
  final int index;
  final List<UserModel> sampleUsers = [];
  final List<StoryItem> storyItems = [];
  var storyController = StoryController();

  StoryPage({required this.snapshot, required this.index}) {

    snapshot.data!.forEach((element) {
      storyItems.add(StoryItem.pageImage(url: element.thumbnailUrl, caption: element.title, controller: storyController),);
    });
  }

  @override
  Widget build(BuildContext context) {

    return StoryView(
      storyItems: storyItems,
      controller: storyController,
      repeat: false,
      onComplete: () { Navigator.pop(context);},
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          } else if (direction == Direction.up) {
            // @TODO: This needs to be checked as it opens in a black screen
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return WebViewController();
            // }));
            }
          }
    );
  }
}
