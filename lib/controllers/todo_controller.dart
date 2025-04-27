import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/core/exceptions.dart';
import 'package:flutter_auth/models/todo.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_auth/services/todo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todosAsyncProvider =
    AsyncNotifierProvider<TodoNotifier, List<Todo>>(TodoNotifier.new);

class TodoNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    try {
      final todos = await locator.get<TodoService>().fetchTodos();
      return todos;
    } on DioException catch (e) {
      throw Exception(handleDioException(e));
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  Future<void> addTodo(String title, String description) async {
    try {
      state = const AsyncValue.loading();
      final newTodo =
          await locator.get<TodoService>().createTodo(title, description);
      state = AsyncValue.data([...state.value!, newTodo]);
    } on DioException catch (e, stk) {
      state = AsyncValue.error(handleDioException(e), stk);
      throw Exception(handleDioException(e));
    } catch (e, stk) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      throw Exception('$e $stk');
    }
  }

  Future<void> updateTodo(BuildContext context, Todo todo) async {
    try {
      await locator.get<TodoService>().updateTodo(todo);
      final updatedTodos =
          state.value!.map((t) => t.id == todo.id ? todo : t).toList();
      state = AsyncValue.data(updatedTodos);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todo updated successfully!')),
        );
      }
    } on DioException catch (e, stk) {
      state = AsyncValue.error(handleDioException(e), stk);
      throw Exception(handleDioException(e));
    } catch (e, stk) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      throw Exception('$e $stk');
    }
  }
}
