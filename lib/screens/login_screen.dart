import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart'; // Chúng ta sẽ tạo file này ở bước 2

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(); 
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);

    final username = _usernameController.text;
    final password = _passwordController.text;

    // Gọi API đăng nhập
    final token = await _apiService.login(username, password);

    setState(() => _isLoading = false);

    if (token != null) {
      // Đăng nhập thành công -> Chuyển sang Home
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(token: token)),
      );
    } else {
      // Đăng nhập thất bại -> Hiện thông báo lỗi
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thất bại! Kiểm tra lại tài khoản.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập CLB Pickleball')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Tài khoản'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Đăng nhập'),
                  ),
          ],
        ),
      ),
    );
  }
}