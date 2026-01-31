using Microsoft.AspNetCore.Mvc;
using Backend.Data; // QUAN TRỌNG: Để tìm thấy ApplicationDbContext

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WalletController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public WalletController(ApplicationDbContext context)
        {
            _context = context;
        }

        // POST: api/Wallet/deposit
        [HttpPost("deposit")]
        public IActionResult Deposit([FromBody] dynamic request)
        {
            return Ok(new { message = "Yêu cầu nạp tiền đã được gửi!" });
        }

        // GET: api/Wallet/transactions
        [HttpGet("transactions")]
        public IActionResult GetTransactions()
        {
            // Trả về lịch sử giao dịch giả để Demo
            var history = new[]
            {
                new { Id = 1, Description = "Nạp tiền vào ví", Amount = 500000, Type = "Deposit", Date = "2026-01-30 10:00" },
                new { Id = 2, Description = "Đặt sân số 1", Amount = -50000, Type = "Payment", Date = "2026-01-31 08:30" }
            };
            return Ok(history);
        }
    }
}