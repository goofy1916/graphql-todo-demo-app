import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'api.dart';
import 'my_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}
