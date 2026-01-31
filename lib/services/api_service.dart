import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart'; // Thêm dòng này

class ApiService {
  static const String baseUrl = "https://luuphong-cntt1708.ddns.net/api";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
    ),
  );

  // --- 1. ĐĂNG KÝ (MỚI) ---
  Future<bool> register(String username, String password, String fullName) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'userName': username,
        'password': password,
        'fullName': fullName,
      });
      return response.statusCode == 200;
    } catch (e) {
      print('Lỗi đăng ký: $e');
      return false;
    }
  }

  // --- 2. ĐĂNG NHẬP (GIỮ NGUYÊN) ---
  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'userName': username,
        'password': password,
      });
      return response.data['token'];
    } catch (e) {
      return null;
    }
  }

  // --- 3. LẤY THÔNG TIN USER (GIỮ NGUYÊN) ---
  Future<Map<String, dynamic>?> getUserProfile(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('/auth/me');
      return response.data;
    } catch (e) {
      return null;
    }
  }

  // --- 4. NẠP TIỀN (MỚI - QUAN TRỌNG ĐỂ DEMO) ---
  // Yêu cầu đề bài: Nạp tiền kèm ảnh bằng chứng [cite: 130, 183]
  Future<bool> deposit(String token, double amount, XFile? imageFile) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // Tạo FormData để gửi file ảnh và số tiền
      FormData formData = FormData.fromMap({
        "amount": amount,
        // Nếu API yêu cầu file ảnh (nếu ko có file thì gửi null cũng được để test)
        if (imageFile != null)
          "proofImage": await MultipartFile.fromFile(imageFile.path, filename: "proof.jpg"),
      });

      // Lưu ý: Endpoint này phải khớp với Backend của bạn (/api/wallet/deposit)
      final response = await _dio.post('/wallet/deposit', data: formData);
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi nạp tiền: $e");
      return false;
    }
  }

  // --- 5. ĐẶT SÂN & LỊCH SỬ (GIỮ NGUYÊN CỦA BẠN) ---
  Future<bool> bookCourt(String token, int courtId, String startTime, String endTime) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('/bookings', data: {
        "courtId": courtId,
        "startTime": startTime,
        "endTime": endTime
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> getMyBookings(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('/bookings/my-bookings'); // Đảm bảo API này đúng
      return response.data;
    } catch (e) {
      return [];
    }
  }
}