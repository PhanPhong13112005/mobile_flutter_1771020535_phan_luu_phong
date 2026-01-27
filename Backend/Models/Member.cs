using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models
{
    [Table("535_Members")] // Yêu cầu đề bài: Tên bảng bắt đầu bằng 3 số cuối MSSV
    public class Member
    {
        [Key]
        public int Id { get; set; }

        public string FullName { get; set; } = string.Empty;

        public DateTime JoinDate { get; set; } = DateTime.Now;

        public double RankLevel { get; set; } = 0; // Rank DUPR

        public bool IsActive { get; set; } = true;

        // Liên kết với Identity User (Tài khoản đăng nhập)
        public string? UserId { get; set; }

        // --- Phần Advanced (Ví & Hạng) ---
        [Column(TypeName = "decimal(18,2)")]
        public decimal WalletBalance { get; set; } = 0;

        public string Tier { get; set; } = "Standard"; // Standard, Silver, Gold, Diamond

        [Column(TypeName = "decimal(18,2)")]
        public decimal TotalSpent { get; set; } = 0;

        public string? AvatarUrl { get; set; }
    }
}