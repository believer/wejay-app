import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  PlayButton(this.isPlaying, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        gradient: new RadialGradient(
          colors: <Color>[Colors.white, Colors.grey[200]],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          new BoxShadow(
            color: Colors.white10,
            spreadRadius: 10.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: new IconButton(
        onPressed: onPressed,
        iconSize: 40.0,
        icon: new Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
