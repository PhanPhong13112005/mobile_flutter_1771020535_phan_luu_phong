import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'booking_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _userProfile;
  List<dynamic> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final profile = await _apiService.getUserProfile(widget.token);
    final bookings = await _apiService.getMyBookings(widget.token);
    if (mounted) {
      setState(() {
        _userProfile = profile;
        _bookings = bookings;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Nền xám nhẹ hiện đại
      appBar: AppBar(
        title: const Text('CLB Pickleball Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookingScreen(token: widget.token)),
          );
          _loadData();
        },
        label: const Text('Đặt Sân Ngay'),
        icon: const Icon(Icons.sports_tennis),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // PHẦN 1: THẺ VÍ (GIAO DIỆN THẺ ATM)
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: Text(
                                _userProfile?['fullName']?.substring(0, 1) ?? 'U',
                                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _userProfile?['fullName'] ?? 'Xin chào!',
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                const Text('Thành viên Hạng Vàng', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Text('SỐ DƯ TÀI KHOẢN', style: TextStyle(color: Colors.white70, letterSpacing: 1.2)),
                        const SizedBox(height: 5),
                        Text(
                          '${_userProfile?['walletBalance']} VNĐ',
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  // PHẦN 2: TIÊU ĐỀ LỊCH SỬ
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Lịch sử đặt sân', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        Text('${_bookings.length} lượt', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),

                  // PHẦN 3: DANH SÁCH LỊCH SỬ (CARD ĐẸP)
                  _bookings.isEmpty
                      ? Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey[300]),
                              const SizedBox(height: 10),
                              const Text('Chưa có lịch đặt sân nào', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true, // Để nằm trong SingleScrollView
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _bookings.length,
                          itemBuilder: (context, index) {
                            final item = _bookings[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.sports_tennis, color: Colors.orange),
                                ),
                                title: Text(
                                  'Sân Pickleball Số ${item['courtId']}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        item['startTime'].toString().substring(0, 16).replaceFirst("T", " "),
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Đã đặt', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 80), // Khoảng trống dưới cùng
                ],
              ),
            ),
    );
  }
}