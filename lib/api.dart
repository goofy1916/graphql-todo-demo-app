import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

HttpLink httpLink = HttpLink(uri: 'http://localhost:3000');

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(link: httpLink, cache: InMemoryCache()),
);

final String getTaskQuery = """
  query{
    allTodos{
      id,
      title,
      completed
    }
  }
""";

final String createTaskMutation = """
  mutation CreateTodo(\$id: ID!, \$title: String!){
    createTodo(id: \$id, title: \$title, completed: false){
      id
    }
  }
""";

final String updateTask = """
  mutation updateTask(\$id: ID!, \$completed: Boolean!){
    updateTodo(id: \$id, completed: \$completed){
    id
    }
  }
""";
