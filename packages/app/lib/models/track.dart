class Track {
  final String artist;
  final String title;
  final String albumUrl;
  final int position;
  final int duration;

  Track({
    this.artist,
    this.title,
    this.albumUrl,
    this.position,
    this.duration,
  });

  String formatTime(int time) {
    int minutes = (time / 60).floor();
    int seconds = time - (60 * minutes);

    if (seconds < 10) {
      return minutes.toString() + ':0' + seconds.toString();
    }

    return minutes.toString() + ':' + seconds.toString();
  }
}
