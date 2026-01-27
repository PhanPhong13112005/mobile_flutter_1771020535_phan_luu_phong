import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BookingScreen extends StatefulWidget {
  final String token;
  const BookingScreen({super.key, required this.token});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _courtIdController = TextEditingController(text: "1"); // Mặc định sân số 1
  // Điền sẵn ngày giờ để test cho nhanh
  final _startTimeController = TextEditingController(text: "2026-01-28T08:00:00");
  final _endTimeController = TextEditingController(text: "2026-01-28T10:00:00");
  
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _handleBooking() async {
    setState(() => _isLoading = true);

    // Lấy dữ liệu
    final int? courtId = int.tryParse(_courtIdController.text);
    final String startTime = _startTimeController.text;
    final String endTime = _endTimeController.text;

    if (courtId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID sân phải là số!')));
      setState(() => _isLoading = false);
      return;
    }

    // Gọi API
    final success = await _apiService.bookCourt(widget.token, courtId, startTime, endTime);

    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đặt sân thành công!')));
      Navigator.pop(context); // Quay về trang chủ
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Thất bại! Kiểm tra lại ngày giờ.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt sân Pickleball')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Thông tin đặt sân', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _courtIdController,
              decoration: const InputDecoration(labelText: 'Mã sân (Court ID)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _startTimeController,
              decoration: const InputDecoration(labelText: 'Bắt đầu (Năm-Tháng-NgàyTBắt:đầu)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _endTimeController,
              decoration: const InputDecoration(labelText: 'Kết thúc (Năm-Tháng-NgàyTKết:thúc)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _handleBooking,
                    icon: const Icon(Icons.check),
                    label: const Text('Xác nhận Đặt sân'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  ),
          ],
        ),
      ),
    );
  }
}