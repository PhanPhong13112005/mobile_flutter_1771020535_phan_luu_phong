using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using Backend.Data;   // QUAN TRỌNG: Để tìm thấy ApplicationDbContext
using Backend.Models; // QUAN TRỌNG: Để tìm thấy Court

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CourtsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public CourtsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Courts
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Court>>> GetCourts()
        {
            // Trả về danh sách sân từ Database
            return await _context.Courts.ToListAsync();
        }

        // POST: api/Courts
        [HttpPost]
        public async Task<ActionResult<Court>> CreateCourt(Court court)
        {
            _context.Courts.Add(court);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetCourts), new { id = court.Id }, court);
        }
    }
}