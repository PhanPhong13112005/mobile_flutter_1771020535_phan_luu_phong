import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _register() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) return;
    setState(() => _isLoading = true);
    
    final success = await _apiService.register(
      _userController.text, 
      _passController.text, 
      _nameController.text
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng ký thành công! Hãy đăng nhập.")));
      Navigator.pop(context); // Quay về màn login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng ký thất bại. Tên tài khoản có thể đã tồn tại.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng Ký Tài Khoản")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _userController, decoration: const InputDecoration(labelText: "Tài khoản", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Mật khẩu", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Họ và tên", border: OutlineInputBorder())),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("ĐĂNG KÝ NGAY"),
              )
            ),
          ],
        ),
      ),
    );
  }
}