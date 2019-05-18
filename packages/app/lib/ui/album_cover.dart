import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AlbumCover extends StatefulWidget {
  final String albumUrl;
  final RunMutation nextTrack;
  final RunMutation previousTrack;

  AlbumCover({
    this.albumUrl,
    this.nextTrack,
    this.previousTrack,
  });

  @override
  State<StatefulWidget> createState() {
    return AlbumCoverState();
  }
}

class AlbumCoverState extends State<AlbumCover>
    with SingleTickerProviderStateMixin {
  Animation<double> _fadeAnimation;
  AnimationController _fadeAnimationController;

  final String dismissQuery = """
    query currentTrack {
      hasNext
      hasPrevious
    }
  """;

  @override
  void initState() {
    super.initState();

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOutQuad,
    );

    _fadeAnimationController.addListener(() => this.setState(() => {}));
    _fadeAnimationController.forward();
  }

  @override
  void didUpdateWidget(AlbumCover oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.albumUrl != widget.albumUrl) {
      _fadeAnimationController.reset();
      _fadeAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  DismissDirection _handleDismissDirection(bool hasNext, bool hasPrevious) {
    if (!hasNext) {
      return DismissDirection.startToEnd;
    }

    if (!hasPrevious) {
      return DismissDirection.endToStart;
    }

    return DismissDirection.horizontal;
  }

  void _handleDismiss(
    DismissDirection direction,
    bool hasNext,
    bool hasPrevious,
  ) {
    if (direction == DismissDirection.startToEnd && hasPrevious) {
      widget.previousTrack(null);
    }

    if (direction == DismissDirection.endToStart && hasNext) {
      widget.nextTrack(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: dismissQuery),
      builder: (QueryResult result, {VoidCallback refetch}) {
        final bool hasNext =
            result.loading ? false : result.data['hasNext'] || false;
        final bool hasPrevious =
            result.loading ? false : result.data['hasPrevious'] || false;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Dismissible(
            direction: _handleDismissDirection(hasNext, hasPrevious),
            resizeDuration: null,
            key: ObjectKey(widget.albumUrl),
            onDismissed: (direction) => _handleDismiss(
                  direction,
                  hasNext,
                  hasPrevious,
                ),
            child: Container(
              height: 275.0,
              width: 275.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.albumUrl),
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 20.0),
                    spreadRadius: -10.0,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
