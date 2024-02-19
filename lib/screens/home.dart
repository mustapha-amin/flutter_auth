import 'package:flutter/material.dart';
import 'package:flutter_auth/controllers/auth_controllers.dart';
import 'package:flutter_auth/controllers/current_user_controller.dart';
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
      body: ref.watch(currentUserProvider).when(
            data: (user) {
              return Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user!.avatar!.url!),
                    radius: 30,
                  ),
                  sbH(30),
                  UserInfo(title: "Username", value: user.username!),
                  UserInfo(title: "Email", value: user.email!),
                  UserInfo(
                    title: "Created at",
                    value: user.createdAt!.toString(),
                  ),
                  UserInfo(title: "Role", value: user.role!),
                  UserInfo(
                    title: "Email is verified",
                    value: user.isEmailVerified.toString(),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      ref.invalidate(currentUserProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh"),
                  )
                ],
              );
            },
            error: (err, stk) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(err.toString()),
                  TextButton.icon(
                    onPressed: () async {
                      ref.invalidate(currentUserProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                  )
                ],
              ),
            ),
            loading: () => const Center(child: Loader()),
          ),
    );
  }
}
