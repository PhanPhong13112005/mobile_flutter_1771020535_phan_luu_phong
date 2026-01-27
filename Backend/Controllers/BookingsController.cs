using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using System.Security.Claims;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BookingsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public BookingsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // POST: api/Bookings
        [HttpPost]
        public async Task<ActionResult<Booking>> PostBooking(Booking booking)
        {
            // 1. Lấy user
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized("Bạn chưa đăng nhập.");

            var member = await _context.Members.FirstOrDefaultAsync(m => m.UserId == userId);
            if (member == null) return NotFound("Không tìm thấy hồ sơ thành viên.");

            // 2. Lấy sân (hoặc giả lập nếu chưa có DB sân)
            var court = await _context.Courts.FindAsync(booking.CourtId);
            if (court == null)
            {
                court = new Court { Id = booking.CourtId, Name = $"Sân {booking.CourtId}", PricePerHour = 100000 };
            }

            // 3. Logic chặn trùng lịch
            if (booking.EndTime <= booking.StartTime)
                return BadRequest("Thời gian kết thúc phải sau thời gian bắt đầu.");

            bool isConflict = await _context.Bookings.AnyAsync(b =>
                b.CourtId == booking.CourtId &&
                b.Id != booking.Id &&
                booking.StartTime < b.EndTime &&
                booking.EndTime > b.StartTime
            );

            if (isConflict) return BadRequest("❌ Sân này đã có người đặt trong khung giờ đó!");

            // 4. Tính tiền
            double totalHours = (booking.EndTime - booking.StartTime).TotalHours;
            decimal totalPrice = (decimal)totalHours * court.PricePerHour;

            if (member.WalletBalance < totalPrice)
                return BadRequest($"❌ Số dư không đủ! Cần {totalPrice:N0}đ.");

            // 5. Trừ tiền & Lưu giao dịch
            member.WalletBalance -= totalPrice;

            var transaction = new WalletTransaction
            {
                MemberId = member.Id,
                Amount = -totalPrice,
                
                // 👇 ĐÃ SỬA DÒNG NÀY (Dùng Enum thay vì String)
                Type = TransactionType.Payment, 
                
                Description = $"Đặt sân {booking.CourtId} ({totalHours:F1}h)",
                CreatedDate = DateTime.Now
            };
            _context.WalletTransactions.Add(transaction);

            // 6. Lưu Booking
            booking.MemberId = member.Id;
            booking.Id = 0;
            
            _context.Bookings.Add(booking);
            await _context.SaveChangesAsync();

            return Ok(new { message = "✅ Đặt sân thành công!", data = booking });
        }

        // GET: api/Bookings/my-bookings
        [HttpGet("my-bookings")]
        public async Task<ActionResult<IEnumerable<Booking>>> GetMyBookings()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var member = await _context.Members.FirstOrDefaultAsync(m => m.UserId == userId);
            if (member == null) return NotFound("Không tìm thấy hồ sơ.");

            return await _context.Bookings
                .Where(b => b.MemberId == member.Id)
                .OrderByDescending(b => b.StartTime)
                .ToListAsync();
        }
    }
}