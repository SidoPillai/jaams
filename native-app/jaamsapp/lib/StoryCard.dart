import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0x00000000),
      elevation: 8.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        height: 200,
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Image(height: 128, width: 128, image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/a/a0/Bill_Gates_2018.jpg"),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 260,
                      height: 2,
                    ),
                    const SizedBox(height: 2),
                    const Text('Title', style: TextStyle(color: Colors.white70, fontSize: 25)),
                    const SizedBox(height: 5),
                    const Text('Snippet', style: TextStyle(color: Colors.white70, fontSize: 20)),
                    const SizedBox(height: 10),
                    const Text('Date', style: TextStyle(color: Colors.white70, fontSize: 20)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}