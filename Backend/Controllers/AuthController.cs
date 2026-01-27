using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Backend.Models;
using Backend.Data;
using Microsoft.EntityFrameworkCore;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly IConfiguration _configuration;
        private readonly ApplicationDbContext _context;

        public AuthController(UserManager<IdentityUser> userManager, SignInManager<IdentityUser> signInManager, IConfiguration configuration, ApplicationDbContext context)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _configuration = configuration;
            _context = context;
        }

        // POST: api/auth/login
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginModel model)
        {
            var result = await _signInManager.PasswordSignInAsync(model.UserName, model.Password, false, false);
            if (result.Succeeded)
            {
                var user = await _userManager.FindByNameAsync(model.UserName);
                var token = GenerateJwtToken(user);
                return Ok(new { token });
            }
            return Unauthorized();
        }

        // GET: api/auth/me (Lấy thông tin ví và user)
        [HttpGet("me")]
        public async Task<IActionResult> GetMe()
        {
            var userId = _userManager.GetUserId(User); // Lấy ID từ Token
            // Tìm Member tương ứng với User này để lấy số dư Ví
            var member = await _context.Members.FirstOrDefaultAsync(m => m.UserId == userId);
            
            if (member == null) return NotFound("Chưa có hồ sơ thành viên");

            return Ok(new { 
                member.FullName, 
                member.WalletBalance, // Quan trọng: Số dư ví
                member.Tier 
            });
        }
        // POST: api/auth/register (Thêm cái này để tạo tài khoản test)
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterModel model)
        {
            var user = new IdentityUser { UserName = model.UserName };
            var result = await _userManager.CreateAsync(user, model.Password);

            if (result.Succeeded)
            {
        // Tạo luôn thông tin Member đi kèm
                var member = new Member
                {
                    UserId = user.Id,
                    FullName = model.FullName,
                    WalletBalance = 5000000, // Tặng sẵn 5 triệu để test
                    Tier = "Standard",
                    JoinDate = DateTime.Now
                };
                _context.Members.Add(member);
                await _context.SaveChangesAsync();
                return Ok("Đăng ký thành công!");
            }
            return BadRequest(result.Errors);
}

// Class Model cho đăng ký (thêm vào cuối file, chỗ LoginModel)
        public class RegisterModel { 
        public string UserName { get; set; } 
        public string Password { get; set; }
        public string FullName { get; set; }
        }

        private string GenerateJwtToken(IdentityUser user)
        {
            var claims = new[] { new Claim(JwtRegisteredClaimNames.Sub, user.Id), new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()) };
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var token = new JwtSecurityToken(_configuration["Jwt:Issuer"], _configuration["Jwt:Audience"], claims, expires: DateTime.Now.AddDays(30), signingCredentials: creds);
            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }

    public class LoginModel { public string UserName { get; set; } public string Password { get; set; } }
}