import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meta/meta.dart';
import 'package:to_do_app/data/todo.dart';
import 'package:to_do_app/todo_bloc/todo_bloc.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(AddTodo(todo));
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  alterTodo(id) {
    context.read<TodoBloc>().add(AlterTodo(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller1 = TextEditingController();
                TextEditingController controller2 = TextEditingController();
                return AlertDialog(
                  elevation: 2,
                  title: const Text('Add a task'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller1,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: 'Task title..',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: controller2,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: 'Task title..',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ))),
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextButton(
                        onPressed: () {
                          addTodo(
                            Todo(
                              id: uuid.v1(),
                              title: controller1.text,
                              subtitle: controller2.text,
                            ),
                          );
                          controller1.text = '';
                          controller2.text = '';
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          foregroundColor:
                              Theme.of(context).colorScheme.onBackground,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            "Done",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('To Do App',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              // var doneItems = state.todos;
              List<Todo> doneItems = state.todos
                  .where((element) => element.isDone == false)
                  .toList();
              List<Todo> undoneItems = state.todos
                  .where((element) => element.isDone == true)
                  .toList();

              //List<Todo> doneItems = todostemp.toList();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: doneItems.length,
                    itemBuilder: (context, int i) {
                      return Card(
                        color: Theme.of(context).colorScheme.primary,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  removeTodo(doneItems[i]);
                                },
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: "delete",
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              state.todos[i].title.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(doneItems[i].subtitle.toString()),
                            trailing: Checkbox(
                                value: doneItems[i].isDone,
                                activeColor: Colors.blueAccent,
                                onChanged: (value) {
                                  final tempid = doneItems[i].id;
                                  alterTodo(tempid);
                                  doneItems = state.todos
                                      .where(
                                          (element) => element.isDone == false)
                                      .toList();
                                }),
                            onTap: () {},
                          ),
                        ),
                      );
                    },
                  ),
                  Text("Completed Tasks"),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: undoneItems.length,
                    itemBuilder: (context, int i) {
                      return Card(
                        color: Theme.of(context).colorScheme.primary,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  removeTodo(undoneItems[i]);
                                },
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: "delete",
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              undoneItems[i].title.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(undoneItems[i].subtitle.toString()),
                            trailing: Checkbox(
                                value: undoneItems[i].isDone,
                                activeColor: Colors.blueAccent,
                                onChanged: (value) {
                                  final tempid = undoneItems[i].id;
                                  alterTodo(tempid);
                                  undoneItems = state.todos
                                      .where(
                                          (element) => element.isDone == false)
                                      .toList();
                                }),
                            onTap: () {},
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else if (state.status == TodoStatus.loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return const Text('Something bad happened');
            }
          },
        ),
      ),
    );
  }
}
