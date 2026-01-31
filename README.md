# HỆ THỐNG QUẢN LÝ CLB PICKLEBALL "VỢT THỦ PHỐ NÚI" (PCM) - MOBILE EDITION

**Môn học:** Lập trình Mobile với Flutter
**Sinh viên thực hiện:** Phan Lưu Phong
**Mã sinh viên:** 1771020535
**Lớp:** CNTT 17-08

---

## 📖 Giới thiệu
Ứng dụng di động giúp quản lý hoạt động của câu lạc bộ Pickleball "Vợt Thủ Phố Núi". Người dùng có thể đặt sân, tham gia giải đấu, quản lý ví điện tử và theo dõi lịch sử giao dịch ngay trên điện thoại.

## 🛠 Công nghệ sử dụng
- **Frontend (Mobile):** Flutter (Dart 3.x), Dio (API), Provider/State Management.
- **Backend:** ASP.NET Core Web API 8.0.
- **Database:** SQL Server.
- **Server Deployment:** Ubuntu VPS (Nginx, Kestrel).

## 🚀 Thông tin Server & API (Dùng để chấm bài)
Dự án đã được Deploy lên VPS, giảng viên có thể test trực tiếp mà không cần chạy Backend cục bộ.

- **Base URL API:** `https://luuphong-cntt1708.ddns.net/api`
- **Swagger Documentation (Admin Check):** [https://luuphong-cntt1708.ddns.net/swagger](https://luuphong-cntt1708.ddns.net/swagger)
- **Host:** 103.146.122.39

## ✨ Tính năng chính
1.  **Hệ thống tài khoản:**
    - Đăng ký / Đăng nhập (Lưu phiên đăng nhập tự động).
    - Xem thông tin cá nhân.
2.  **Đặt sân (Booking):**
    - Xem danh sách sân.
    - Chọn giờ và đặt sân trực tuyến.
    - Kiểm tra sân trống/bận.
3.  **Ví điện tử (Wallet):**
    - Xem số dư hiện tại.
    - Nạp tiền (Demo flow).
    - Xem lịch sử giao dịch (Nạp tiền, thanh toán phí sân).
4.  **Giải đấu (Tournaments):**
    - Xem danh sách giải đấu sắp diễn ra.
    - Đăng ký tham gia giải.

## 📱 Hướng dẫn cài đặt & Chạy ứng dụng (Mobile)

### Cách 1: Cài đặt file APK (Khuyến nghị)
Trong thư mục nộp bài có đính kèm file `app-release.apk`. Giảng viên có thể cài đặt trực tiếp lên thiết bị Android để kiểm tra nhanh nhất.

### Cách 2: Chạy từ Source Code
Yêu cầu: Đã cài đặt Flutter SDK và máy ảo/máy thật Android.

1. **Mở terminal tại thư mục dự án:**
   ```bash
   cd mobile_flutter_1771020535_phan_luu_phong
2. **Tải các thư viện:**
   ```bash
   flutter pub get
3. **Chạy ứng dụng:**
   ```bash
   flutter run
Lưu ý: Ứng dụng đã được cấu hình sẵn để kết nối tới Server VPS (https://luuphong-cntt1708.ddns.net), không cần cấu hình IP cục bộ.
🧪 Kịch bản Demo (Testing Flow)
Để kiểm tra chức năng hệ thống, xin hãy thực hiện theo trình tự sau:

Đăng ký: Tạo một tài khoản mới tại màn hình Đăng ký.

Đăng nhập: Truy cập vào ứng dụng với tài khoản vừa tạo.

Nạp tiền: Vào tab Ví -> Chọn Nạp tiền -> Nhập số tiền (VD: 500,000) -> Xác nhận.

Kiểm tra ví: Số dư trong ví sẽ thay đổi (hoặc chờ admin duyệt).

Đặt sân: Vào tab Đặt sân -> Chọn Sân số 1 (Hoặc sân bất kỳ) -> Chọn giờ -> Xác nhận đặt.

Kiểm tra kết quả:

Trên App: Báo thành công.

Trên Web Admin (Swagger): Gọi API GET /api/bookings để thấy dữ liệu vừa tạo từ App.