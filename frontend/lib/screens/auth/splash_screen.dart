import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Artificial delay for smooth transition
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // The authProvider build method already checks token and validates it
    final authState = await ref.read(authProvider.future);
    
    if (!mounted) return;

    if (authState != null) {
      // Navigate to Home
      context.go('/notes');
    } else {
      // Navigate to Login
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.note_alt_rounded, size: 80, color: Color(0xFF6750A4)),
            const Gap(16),
            Text(
              'Notes App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6750A4),
                  ),
            ),
            const Gap(32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
