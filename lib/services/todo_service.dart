import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_auth/core/endpoints.dart';
import 'package:flutter_auth/core/exceptions.dart';
import 'package:flutter_auth/models/todo.dart';

class TodoService {
  final Dio dio;
  TodoService({required this.dio});

  Future<List<Todo>> fetchTodos() async {
    try {
      final res = await dio.get(
        ApiEndpoints.todos,
      );
      log(res.data.toString());
      final data = res.data['data'] as List<dynamic>;
      final todos = data.map((e) => Todo.fromJson(e)).toList();
      return todos;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Todo> createTodo(String title, String description) async {
    try {
      final res = await dio.post(
        ApiEndpoints.todos,
        data: {'title': title, 'description': description},
      );
      return Todo.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> updateTodo(Todo todo) async {
    try {
      await dio.patch('${ApiEndpoints.todos}/${todo.id}', data: todo.toJson());
      return 'Todo updated successfully';
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}
