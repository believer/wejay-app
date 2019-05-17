import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:wejay/ui/play_button.dart';
import 'package:wejay/models/track.dart';
import 'package:wejay/ui/progress_bar.dart';

class NowPlayingPage extends StatelessWidget {
  final String currentTrackQuery = """
    query currentTrack {
      isPlaying
      currentTrack {
        albumArtURL
        artist
        title
        position
        duration
      }
    }
  """;

  final String togglePlayingMutation = """
    mutation togglePlaying {
      togglePlaying
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFf7d391),
            Color(0xFFf0b058),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Query(
              options: QueryOptions(
                document: currentTrackQuery,
                pollInterval: 1,
              ),
              builder: (QueryResult result, {VoidCallback refetch}) {
                if (result.loading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (result.data == null ||
                    result.data['currentTrack'] == null) {
                  return Center(
                      child: Text("Nothing is playing at the moment"));
                }

                final Map<String, dynamic> currentTrack =
                    result.data['currentTrack'];

                final Track track = new Track(
                  artist: currentTrack['artist'],
                  title: currentTrack['title'],
                  albumUrl: currentTrack['albumArtURL'],
                  position: currentTrack['position'],
                  duration: currentTrack['duration'],
                );

                return Column(
                  children: [
                    Container(
                      height: 275.0,
                      width: 275.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(track.albumUrl),
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
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                        top: 40.0,
                        left: 40.0,
                        right: 40.0,
                      ),
                      child: Text(
                        track.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      track.artist,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ProgressBar(
                      duration: track.duration,
                      position: track.position,
                      positionAsString: track.formatTime(track.position),
                      durationAsString: track.formatTime(track.duration),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Mutation(
                            options: MutationOptions(
                              document: togglePlayingMutation,
                            ),
                            builder: (
                              RunMutation runMutation,
                              QueryResult mutationResult,
                            ) {
                              final bool isPlaying = result.data['isPlaying'];

                              return PlayButton(
                                isPlaying,
                                onPressed: () => {runMutation(null)},
                              );
                            },
                            update: (Cache cache, QueryResult result) {
                              print(cache);

                              return cache;
                            },
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
