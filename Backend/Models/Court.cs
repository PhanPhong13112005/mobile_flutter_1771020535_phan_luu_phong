using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models
{
    [Table("535_Courts")]
    public class Court
    {
        [Key]
        public int Id { get; set; }

        public string Name { get; set; } = string.Empty; // Sân 1, Sân 2...
        public bool IsActive { get; set; } = true;
        public string? Description { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal PricePerHour { get; set; } // Giá thuê mỗi giờ
    }
}