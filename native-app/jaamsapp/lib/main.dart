import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'HomePage.dart';

var testUrl = "http://localhost:8080/stories/all";
var prodUrl = "http://ec2-3-101-45-128.us-west-1.compute.amazonaws.com:8080/stories/all";

Future<List<StoryMap>> fetchAlbum() async {
  final response = await http.get(Uri.parse(prodUrl));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    debugPrint('Response: $storyMapFromJson(jsonDecode(response.body)');
    return storyMapFromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class StoryMap {
  final String id;
  final String storyMapsUrl;
  final String thumbnailUrl;
  final String title;
  final String snippet;
  final String audio;

  StoryMap({
    required this.id,
    required this.storyMapsUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.snippet,
    required this.audio
  });
}

List<StoryMap> storyMapFromJson(List<dynamic> json) {
  List<StoryMap> storyMaps = [];

  json.forEach((element) {
    storyMaps.add(StoryMap(
        id: element['id'],
        storyMapsUrl: element['storyMapsUrl'],
        thumbnailUrl: element['thumbnailUrl'],
        title: element['title'],
        snippet: element['snippet'],
        audio: element['audio']));
  });
  return storyMaps;
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<StoryMap>> futureStoryMaps;

  @override
  void initState() {
    super.initState();
    futureStoryMaps = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(futureStoryMaps: futureStoryMaps),
    );
  }
}

void main() => runApp(MyApp());
