import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thư viện để định dạng tiền tệ (300.000 đ)
import '../../services/api_service.dart';

class WalletScreen extends StatefulWidget {
  final String token;
  const WalletScreen({super.key, required this.token});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _amountController = TextEditingController();
  
  Map<String, dynamic>? _profile;
  
  // Biến này để kiểm soát vòng tròn xoay xoay (Loading)
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Hàm tải thông tin ví
  void _loadProfile() async {
    try {
      final data = await _apiService.getUserProfile(widget.token);
      if (mounted) setState(() => _profile = data);
    } catch (e) {
      print(e);
    }
  }

  // Hàm hiển thị hộp thoại nhập số tiền
  void _showDepositDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nạp Tiền Vào Ví"),
        content: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Nhập số tiền", 
            suffixText: "VNĐ",
            border: OutlineInputBorder()
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text("Hủy")
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Đóng hộp thoại trước
              _submitDeposit();   // Rồi mới xử lý nạp
            },
            child: const Text("Nạp Ngay"),
          )
        ],
      ),
    );
  }

  // Hàm xử lý gọi API nạp tiền
  Future<void> _submitDeposit() async {
    // 1. Bắt đầu loading -> Hiện vòng tròn
    setState(() => _isLoading = true);

    double amount = double.tryParse(_amountController.text) ?? 0;
    
    // Gọi API (Lưu ý: Bạn cần chắc chắn hàm deposit đã có trong api_service.dart)
    // Nếu chưa có hàm deposit, API sẽ trả về false, code vẫn chạy an toàn không lỗi app.
    bool success = await _apiService.deposit(widget.token, amount, null);
    
    // 2. Kết thúc loading -> Tắt vòng tròn
    if (mounted) {
      setState(() => _isLoading = false);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Yêu cầu nạp tiền thành công!"), backgroundColor: Colors.green)
        );
        _amountController.clear(); // Xóa ô nhập
        _loadProfile(); // Tải lại số dư mới
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Lỗi nạp tiền"), backgroundColor: Colors.red)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Định dạng tiền Việt Nam (Ví dụ: 100,000 đ)
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    
    // Lấy số dư từ dữ liệu tải về, nếu chưa có thì là 0
    double balance = double.tryParse(_profile?['walletBalance']?.toString() ?? "0") ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ví Điện Tử"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _loadProfile, icon: const Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- THẺ ATM ẢO ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ]
              ),
              child: Column(
                children: [
                  const Text(
                    "Số dư khả dụng", 
                    style: TextStyle(color: Colors.white70, fontSize: 16)
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currencyFormat.format(balance), 
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 32, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 20),
                  
                  // --- NÚT NẠP TIỀN (CHỖ SỬA LỖI _isLoading) ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _showDepositDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        )
                      ),
                      // Nếu đang loading thì hiện vòng tròn xoay, ngược lại hiện icon + chữ
                      icon: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                          : const Icon(Icons.account_balance_wallet),
                      label: Text(
                        _isLoading ? " Đang xử lý..." : "NẠP TIỀN VÀO VÍ",
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // --- LỊCH SỬ GIAO DỊCH (DEMO) ---
            const Align(
              alignment: Alignment.centerLeft, 
              child: Text("Lịch sử giao dịch gần đây", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ),
            const SizedBox(height: 10),
            
            // Danh sách giả lập (Khi nào rảnh bạn gọi API lấy list thật sau)
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildTransactionItem("Nạp tiền", "+ 500.000 đ", Colors.green, "Hôm nay"),
                _buildTransactionItem("Đặt sân cầu lông", "- 120.000 đ", Colors.red, "Hôm qua"),
                _buildTransactionItem("Thưởng giải đấu", "+ 200.000 đ", Colors.green, "28/01/2026"),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget con để vẽ từng dòng lịch sử cho gọn code
  Widget _buildTransactionItem(String title, String amount, Color color, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10)
          ),
          child: const Icon(Icons.receipt_long, color: Colors.indigo),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(
          amount, 
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)
        ),
      ),
    );
  }
}