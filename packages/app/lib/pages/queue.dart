import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Queue extends StatelessWidget {
  final String queueQuery = """
    query queue {
      upcomingTracks {
        title
        artist
        albumArtURI
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
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Text(
                "Upcoming tracks",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Query(
                options: QueryOptions(
                  document: queueQuery,
                ),
                builder: (QueryResult result, {VoidCallback refetch}) {
                  if (result.loading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (result.data == null ||
                      result.data['upcomingTracks'] == null) {
                    return Center(child: Text('Nothing in queue'));
                  }

                  List queue = result.data['upcomingTracks'].toList();

                  return ListView.builder(
                    itemCount: queue.length,
                    itemBuilder: (context, index) {
                      final track = queue[index];

                      return Card(
                        color: Color(0xFFFDE4C4),
                        child: ListTile(
                          trailing: Text((index + 1).toString()),
                          leading: Image(
                            image: NetworkImage(track['albumArtURI']),
                          ),
                          title: Text(
                            track['title'],
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          subtitle: Text(
                            track['artist'],
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
