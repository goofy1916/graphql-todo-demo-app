import 'package:flutter/material.dart';
import 'package:graphql_demo/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final newTaskController = TextEditingController();

  Future<String> onCreate(BuildContext context, id) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Mutation(
            options: MutationOptions(
              documentNode: gql(createTaskMutation),
            ),
            builder: (MultiSourceResult Function(Map<String, dynamic>,
                        {Object optimisticResult})
                    runMutation,
                QueryResult result) {
              return AlertDialog(
                title: Text('Enter a new task'),
                content: Row(
                  children: [
                    new Expanded(
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Task description',
                            hintText: 'Do stuff',
                            errorText: result.hasException
                                ? result.exception.toString()
                                : null),
                        controller: newTaskController,
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      runMutation({'title': newTaskController.text, 'id': id+1});
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(documentNode: gql(getTaskQuery), pollInterval: 1),
      builder: (QueryResult result,
          {dynamic Function(FetchMoreOptions) fetchMore,
          Future<QueryResult> Function() refetch}) {
        return Scaffold(
          body: Center(
            child: result.hasException
                ? Text(result.exception.toString())
                : result.loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : TaskList(
                        list: result.data['allTodos'], onRefresh: refetch),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => !result.hasException && !result.loading
                ? this.onCreate(context, result.data['allTodos'].length)
                : () {},
            tooltip: 'New Task',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class TaskList extends StatelessWidget {
  final list;
  final onRefresh;

  const TaskList({Key key, this.list, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(documentNode: gql(updateTask)),
      builder: (RunMutation runMutation, QueryResult result) {
        return ListView.builder(
          itemCount: this.list.length,
          itemBuilder: (context, index) {
            final task = this.list[index];
            return CheckboxListTile(
              title: Text(task['title']),
              value: task['completed'],
              onChanged: (_) {
                runMutation({'id': index + 1, 'completed': !task['completed']});
                onRefresh();
              },
            );
          },
        );
      },
    );
  }
}
