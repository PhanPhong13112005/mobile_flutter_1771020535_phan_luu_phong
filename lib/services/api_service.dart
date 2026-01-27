import 'package:dio/dio.dart';

class ApiService {
  // QUAN TRỌNG: Nếu chạy máy ảo Android thì dùng 10.0.2.2
  // Nếu chạy máy thật hoặc iOS thì phải dùng IP LAN của máy tính (VD: 192.168.1.x)
  static const String baseUrl = 'http://localhost:5110/api';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
    ),
  );

  // Hàm đăng nhập
  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'userName': username,
        'password': password,
      });

      // Trả về Token nếu thành công
      return response.data['token'];
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      return null;
    }
  }

  // Hàm lấy thông tin user (Số dư ví)
  Future<Map<String, dynamic>?> getUserProfile(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token'; // Gắn token vào header
      final response = await _dio.get('/auth/me');
      return response.data;
    } catch (e) {
      print('Lỗi lấy thông tin: $e');
      return null;
    }
  }
  // ... (Các hàm login, getUserProfile giữ nguyên)

  // THÊM HÀM NÀY: Gọi API Đặt sân
  // ... (Các hàm login, getUserProfile giữ nguyên ở trên)

  // 👇 DÁN HÀM NÀY VÀO:
  Future<bool> bookCourt(String token, int courtId, String startTime, String endTime) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token'; // Gắn token để Server biết ai đặt
      
      final response = await _dio.post('/bookings', data: {
        "memberId": 0, // Backend tự lấy ID từ token, gửi 0 cũng được
        "courtId": courtId,
        "startTime": startTime, // Định dạng chuẩn: "2026-01-28T08:00:00"
        "endTime": endTime
      });

      return response.statusCode == 200; // Nếu thành công trả về true
    } catch (e) {
      print('Lỗi đặt sân: $e');
      if (e is DioException) {
        print('Chi tiết lỗi Server: ${e.response?.data}');
      }
      return false; // Nếu lỗi trả về false
    }
  }
  // ... (Các hàm cũ giữ nguyên)

  // 👇 THÊM HÀM NÀY: Lấy danh sách lịch sử
  Future<List<dynamic>> getMyBookings(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('/bookings/my-bookings');
      return response.data; // Trả về danh sách []
    } catch (e) {
      print('Lỗi lấy lịch sử: $e');
      return []; // Lỗi thì trả về danh sách rỗng
    }
  }
}