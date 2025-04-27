import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_auth/controllers/auth_controllers.dart';
import 'package:flutter_auth/controllers/current_user_controller.dart';
import 'package:flutter_auth/controllers/todo_controller.dart';
import 'package:flutter_auth/screens/add_todo.dart';
import 'package:flutter_auth/utils/extensions.dart';
import 'package:flutter_auth/utils/spacing.dart';
import 'package:flutter_auth/widgets/loader.dart';
import 'package:flutter_auth/widgets/user_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logOut(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ref.watch(todosAsyncProvider).when(
        data: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ...data.map((todo) {
                  return CheckboxListTile(
                    title: Text(todo.title),
                    value: todo.isComplete,
                    onChanged: (_) {
                      ref.read(todosAsyncProvider.notifier).updateTodo(
                            context,
                            todo.copyWith(isComplete: !todo.isComplete),
                          );
                    },
                  );
                })
              ],
            ),
          );
        },
        error: (error, stk) {
          return Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
        loading: () {
          return Loader();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AddTodo());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
