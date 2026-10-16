import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'vn.edu.fpt.screen/home_screen.dart';
import 'vn.edu.fpt.screen/login_screen.dart';
import 'vn.edu.fpt.service/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FPT School App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const _AuthGate(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  final _storage = const FlutterSecureStorage();
  bool? _authenticated;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final accessToken = await _storage.read(key: 'accessToken');
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (accessToken == null || refreshToken == null) {
      if (mounted) setState(() => _authenticated = false);
      return;
    }
    try {
      await AuthService().refresh();
      if (mounted) setState(() => _authenticated = true);
    } catch (_) {
      await AuthService().clearSession();
      if (mounted) setState(() => _authenticated = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_authenticated == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _authenticated! ? const HomeScreen() : const LoginScreen();
  }
}
