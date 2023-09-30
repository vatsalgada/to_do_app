import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:to_do_app/data/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<TodoStarted>(_onStarted);
    on<AddTodo>(_onAddedTodo);
    on<RemoveTodo>(_onRemoveTodo);
    on<AlterTodo>(_onAlterTodo);
  }
  
  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    return TodoState.fromJson(json);
  }
  
  @override
  Map<String, dynamic>? toJson(TodoState state) {
    return state.toJson();
  }

  void _onStarted(TodoStarted event, Emitter<TodoState> emit) {
    if(state.status == TodoStatus.success) return;
    emit(state.copyWith(
      todos: state.todos,
      status: TodoStatus.success,
    ));
  }

  void _onAddedTodo(AddTodo event, Emitter<TodoState> emit) {
     emit(
    state.copyWith(
      status: TodoStatus.loading
    )
     );

     try{
      List<Todo> temp = [];
      temp.addAll(state.todos);
      temp.insert(0, event.todo);
      emit(
        state.copyWith(
          todos: temp,
          status: TodoStatus.success,
        )
      );
     }catch(e){
      emit(
        state.copyWith(
          status: TodoStatus.success
        )
      );
     }
  }

  void _onRemoveTodo(RemoveTodo event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        status: TodoStatus.loading
      )
    );
    try {
      state.todos.remove(event.todo);
      emit(
        state.copyWith(
          todos: state.todos,
          status: TodoStatus.success,
        )
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error
        )
      );
    }
  }

  void _onAlterTodo(AlterTodo event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        status: TodoStatus.loading
      )
    );
    try {
      state.todos[event.index].isDone = !state.todos[event.index].isDone;
      emit(
        state.copyWith(
          todos: state.todos,
          status: TodoStatus.success,
        )
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error
        )
      );
    }
  }
}
