import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final String positionAsString;
  final String durationAsString;
  final int position;
  final int duration;

  ProgressBar({
    this.positionAsString,
    this.durationAsString,
    this.position,
    this.duration,
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
      padding: EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.positionAsString,
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
                value: widget.position / widget.duration,
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
            ),
          ),
          Text(
            widget.durationAsString,
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
