import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_auth/services/locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = FutureProvider((ref) async {
  final authService = locator.get<AuthService>();
  return await authService.getCurrentUser();
});
