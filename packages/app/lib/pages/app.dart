import 'package:flutter/material.dart';
import 'package:wejay/pages/queue.dart';
import 'package:wejay/pages/now_playing.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: [
          NowPlayingPage(),
          Queue(),
        ],
      ),
    );
  }
}
