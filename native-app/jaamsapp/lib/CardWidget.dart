import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class CardWidget extends StatelessWidget {
  final AsyncSnapshot<List<StoryMap>> snapshot;
  final int index;
  final Function delete;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  CardWidget({required this.snapshot, required this.index, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color(0x002625),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                    child: Image.network(
                      snapshot.data![index].thumbnailUrl,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      snapshot.data![index].title,
                      style: TextStyle(color: Color(0xFFEDF3F3)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Text(
                        snapshot.data![index].snippet,
                        style: TextStyle(color: Color(0xFF749392)),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: IconButton(
                      alignment: Alignment.topRight,
                      icon: Icon(Icons.close),
                      color: Color(0xFF749392),
                      iconSize: 15,
                      onPressed: () async {
                        http.post(
                          Uri.parse(
                              'http://ec2-3-101-45-128.us-west-1.compute.amazonaws.com:8080/stories/remove?id=${snapshot.data![index].id}'),
                        );
                        delete();
                      },
                    ),
                  ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  iconSize: 15,
                  icon: SvgPicture.asset('assets/16-applications-16.svg'),
                  onPressed: () async {
                    String url = snapshot.data![index].storyMapsUrl;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  iconSize: 15,
                  icon: SvgPicture.asset('assets/16-share-ios-16.svg'),
                  onPressed: () async {
                    String url = snapshot.data![index].storyMapsUrl;
                    _onShare(context, url);
                  },
                ),
              ),
              Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      "Last Modified: May 4, 2021",
                      style: TextStyle(color: Color(0xFF749392)),
                    ),
                  )),
              Expanded(
                flex: 1,
                child: IconButton(
                  iconSize: 15,
                  icon: !isPlaying ? SvgPicture.asset('assets/16-play-16-f.svg') :
                    SvgPicture.asset('asset/16-pause-16-f.svg'),
                  onPressed: () async {
                    int result = await audioPlayer.play(
                        "http://ec2-3-101-45-128.us-west-1.compute.amazonaws.com:8080/stories/audio?id=${snapshot.data![index].id}");
                    if (result == 1) {
                      // success
                      // @Todo : Change icon once it is playing
                      isPlaying = true;
                      print("Success");
                    } else {
                      print("Failure");
                    }
                  },
                  // },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _onShare(BuildContext context, String url) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(url, subject: "Share storyboard", sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

// play() async {
//   int result = await audioPlayer.play("http://ec2-3-101-45-128.us-west-1.compute.amazonaws.com:8080/stories/audio?id=b9d7b073400c4c18950469ef79efe98a");
//   if (result == 1) {
//     // success
//     isPlaying = true;
//     print("Success");
//   } else {
//     print("Failure");
//   }
//
// }
}
