import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../main_layout.dart';
import 'register_screen.dart'; // Import màn hình đăng ký

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      final token = await _apiService.login(_userController.text, _passController.text);
      if (token != null && mounted) {
        // Đăng nhập thành công -> Vào MainLayout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainLayout(token: token)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sai tài khoản hoặc mật khẩu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sports_tennis, size: 80, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text("PICKLEBALL PRO", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const SizedBox(height: 40),
              TextField(
                controller: _userController, 
                decoration: const InputDecoration(labelText: "Tài khoản", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passController, 
                obscureText: true, 
                decoration: const InputDecoration(labelText: "Mật khẩu", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("ĐĂNG NHẬP", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ),
              const SizedBox(height: 15),
              // Nút chuyển sang Đăng ký
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const RegisterScreen())
                  );
                }, 
                child: const Text("Chưa có tài khoản? Đăng ký ngay")
              )
            ],
          ),
        ),
      ),
    );
  }
}