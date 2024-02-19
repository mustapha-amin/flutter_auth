import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentScreenProvider = StateProvider((ref) {
  return true;
});

void toggleCurrentScreen(WidgetRef ref) {
  final isLogin = ref.watch(currentScreenProvider);
  ref.read(currentScreenProvider.notifier).state = !isLogin;
}
