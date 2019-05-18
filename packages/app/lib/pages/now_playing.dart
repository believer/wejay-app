import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:wejay/ui/play_button.dart';
import 'package:wejay/models/track.dart';
import 'package:wejay/ui/progress_bar.dart';
import 'package:wejay/ui/album_cover.dart';
import 'package:wejay/ui/track_meta.dart';

class NowPlayingPage extends StatelessWidget {
  final String currentTrackQuery = """
    query currentTrack {
      currentTrack {
        albumArtURL
        artist
        title
        position
        duration
      }
    }
  """;

  final String nextTrackMutation = """
    mutation nextTrack {
      next {
        title
      }
    }
  """;

  final String previousTrackMutation = """
    mutation previousTrack {
      previous {
        title
      }
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
                pollInterval: 2,
              ),
              builder: (QueryResult result, {VoidCallback refetch}) {
                if (result.loading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (result.data == null ||
                    result.data['currentTrack'] == null) {
                  return Center(
                    child: Text(
                      'Nothing is playing at the moment',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  );
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
                    Mutation(
                      options: MutationOptions(
                        document: nextTrackMutation,
                      ),
                      builder: (
                        RunMutation nextMutation,
                        QueryResult nextTrackResult,
                      ) {
                        return Mutation(
                          options: MutationOptions(
                            document: previousTrackMutation,
                          ),
                          builder: (
                            RunMutation previousMutation,
                            QueryResult previousTrackResult,
                          ) {
                            return AlbumCover(
                              albumUrl: track.albumUrl,
                              nextTrack: nextMutation,
                              previousTrack: previousMutation,
                            );
                          },
                        );
                      },
                    ),
                    TrackMeta(track: track),
                    ProgressBar(track: track),
                    PlayButton(),
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
