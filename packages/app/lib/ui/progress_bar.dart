import 'package:flutter/material.dart';
import 'package:wejay/models/track.dart';

class ProgressBar extends StatefulWidget {
  final Track track;

  ProgressBar({
    this.track,
  });

  @override
  State<StatefulWidget> createState() {
    return ProgressBarState();
  }
}

class ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.track.formatTime(widget.track.position),
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Container(
              width: 200,
              child: LinearProgressIndicator(
                value: widget.track.position / widget.track.duration,
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
            ),
          ),
          Text(
            widget.track.formatTime(widget.track.duration),
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
