import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PlayButton extends StatelessWidget {
  final String isPlayingQuery = """
    query isPlaying {
      isPlaying
    }
  """;

  final String togglePlayingMutation = """
    mutation togglePlaying {
      togglePlaying
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: isPlayingQuery, pollInterval: 5),
      builder: (QueryResult result, {VoidCallback refetch}) {
        final bool isPlaying =
            result.loading ? false : result.data['isPlaying'] || false;

        return Mutation(
          options: MutationOptions(
            document: togglePlayingMutation,
          ),
          builder: (
            RunMutation runMutation,
            QueryResult mutationResult,
          ) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: <Color>[Colors.white, Colors.grey[200]],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white10,
                    spreadRadius: 10.0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: () => runMutation(null),
                iconSize: 40.0,
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.grey[800],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
