import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/data/todo.dart';
import 'package:to_do_app/todo_bloc/todo_bloc.dart';

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

  alterTodo(Todo todo, index) {
    context.read<TodoBloc>().add(AlterTodo(index));
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
                return const AlertDialog(
                  elevation: 2,
                  title: Text('Add a task'),
                  content: Column(
                    children: [],
                  ),
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
              return Container();
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
