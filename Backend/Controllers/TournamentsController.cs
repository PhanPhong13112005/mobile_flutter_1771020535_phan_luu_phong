using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Backend.Data; // QUAN TRỌNG: Để tìm thấy ApplicationDbContext

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TournamentsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public TournamentsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Tournaments
        [HttpGet]
        public ActionResult<IEnumerable<dynamic>> GetTournaments()
        {
            // Trả về dữ liệu giả để App hiển thị (Demo)
            var fakeData = new List<dynamic>
            {
                new { Id = 1, Name = "Giải Mùa Hè 2026", EntryFee = 200000, StartDate = "2026-06-01", Status = "Open" },
                new { Id = 2, Name = "Pickleball Mở Rộng", EntryFee = 500000, StartDate = "2026-08-15", Status = "Upcoming" }
            };
            return Ok(fakeData);
        }

        // POST: api/Tournaments/1/join
        [HttpPost("{id}/join")]
        public IActionResult JoinTournament(int id)
        {
            return Ok(new { message = "Đăng ký tham gia thành công!", tournamentId = id });
        }
    }
}