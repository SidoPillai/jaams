import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'StoryWidget.dart';
import 'CardWidget.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.futureStoryMaps,
  }) : super(key: key);

  final Future<List<StoryMap>> futureStoryMaps;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Future<List<StoryMap>> currentStoryMaps = widget.futureStoryMaps;

    return FutureBuilder<List<StoryMap>>(
        future: currentStoryMaps,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                backgroundColor: HexColor("#002625"),
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Color(0x002E2C),
                  title: Text(
                    "J.A.A.M.S",
                    style: TextStyle(color: Color(0xFFEDF3F3)),
                  ),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                        child: Container(
                            height: 100,
                            child: StoryWidget(
                              snapshot: snapshot,
                            ))),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (ctx, index) {
                          return CardWidget(
                              index: index,
                              snapshot: snapshot,
                              delete: () {
                                setState(() {
                                  snapshot.data!.removeAt(index);
                                });
                              });
                        },
                      ),
                    ),
                  ],
                ));
          } else {
            return Text("${snapshot.error}");
          }
        });
  }
}
