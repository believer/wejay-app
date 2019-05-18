import 'package:wejay/models/track.dart';
import 'package:flutter/material.dart';

class TrackMeta extends StatefulWidget {
  final Track track;

  TrackMeta({Key key, this.track}) : super(key: key);

  @override
  TrackMetaState createState() {
    return new TrackMetaState();
  }
}

class TrackMetaState extends State<TrackMeta>
    with SingleTickerProviderStateMixin {
  Animation<EdgeInsets> padding;
  Animation<double> _textAnimation;
  AnimationController _textAnimationController;

  @override
  initState() {
    super.initState();

    _textAnimationController = new AnimationController(
      duration: new Duration(milliseconds: 300),
      vsync: this,
    );

    _textAnimation = new CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.linear,
    );

    padding = new Tween<EdgeInsets>(
      begin: const EdgeInsets.only(left: 30.0),
      end: const EdgeInsets.only(left: 0.0),
    ).animate(
      new CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeIn,
      ),
    );

    _textAnimationController.addListener(() => this.setState(() => {}));
    _textAnimationController.forward();
  }

  @override
  void didUpdateWidget(TrackMeta oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.track.title != widget.track.title) {
      this.setState(() {
        _textAnimationController.reset();
        _textAnimationController.forward();
      });
    }
  }

  @override
  dispose() {
    _textAnimationController.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: padding.value,
      child: new FadeTransition(
        opacity: _textAnimation,
        child: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 10.0,
                left: 40.0,
                right: 40.0,
              ),
              child: Text(
                widget.track.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              widget.track.artist,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: new AnimatedBuilder(
        animation: _textAnimationController,
        builder: _buildAnimation,
      ),
    );
  }
}
