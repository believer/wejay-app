import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:wejay/pages/app.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: 'http://192.168.110.190:4000',
    );

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink as Link,
      ),
    );

    return GraphQLProvider(
      child: DefaultTabController(length: 2, child: App()),
      client: client,
    );
  }
}
