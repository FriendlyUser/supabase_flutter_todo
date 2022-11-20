import 'package:flutter/material.dart';
import 'package:supabase_flutter_todo/api/api.dart';
import 'package:supabase_flutter_todo/model/todo_model.dart';
import 'package:supabase_flutter_todo/screen/add_todo.dart';

import '../api/sp_client.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<TodoModel>? futureTodoList;

  @override
  void initState() {
    super.initState();
    futureTodoList = fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Center(
        child: FutureBuilder<TodoModel>(
          future: futureTodoList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    var listItem = snapshot.data!.todos[index];
                    var isDone = listItem.isDone;
                    return ListTile(
                      title: Text(listItem.title),
                      subtitle: Text(listItem.description),
                      onTap: () => {
                        // open menu for delete item?
                        // alert menu
                        showMenu(
                          position: RelativeRect.fromSize(
                            Rect.fromCenter(
                                center: Offset.zero, width: -100, height: -100),
                            const Size(100, 100),
                          ),
                          items: <PopupMenuEntry>[
                            PopupMenuItem(
                              child: Row(
                                children: const <Widget>[
                                  Icon(Icons.delete),
                                  Text("Delete"),
                                ],
                              ),
                            )
                          ],
                          context: context,
                        )
                      },
                      trailing: isDone
                          ? IconButton(
                              icon: const Icon(
                                  Icons.radio_button_checked_outlined),
                              onPressed: () {
                                SBHelper.setDone(listItem.id, false);
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  setState(() {
                                    futureTodoList = fetchTodos();
                                  });
                                });
                              })
                          : IconButton(
                              icon: const Icon(
                                  Icons.radio_button_unchecked_outlined),
                              onPressed: () {
                                // send api call to check the todo
                                SBHelper.setDone(listItem.id, true);
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  setState(() {
                                    futureTodoList = fetchTodos();
                                  });
                                });
                              }),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          // go to add todo page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodo()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<TodoModel> fetchTodos() async {
    final todoList = await SBHelper.getAllTodo();
    return TodoModel.fromJson(todoList);
  }
}
