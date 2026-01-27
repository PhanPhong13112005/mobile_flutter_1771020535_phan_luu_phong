using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models
{
    public enum BookingStatus { PendingPayment, Confirmed, Cancelled, Completed }

    [Table("535_Bookings")]
    public class Booking
    {
        [Key]
        public int Id { get; set; }

        public int CourtId { get; set; }
        [ForeignKey("CourtId")]
        public Court? Court { get; set; }

        public int MemberId { get; set; }
        [ForeignKey("MemberId")]
        public Member? Member { get; set; }

        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal TotalPrice { get; set; }

        public int? TransactionId { get; set; } // Liên kết giao dịch trừ tiền
        
        // Advanced
        public bool IsRecurring { get; set; } = false;
        public string? RecurrenceRule { get; set; }
        public int? ParentBookingId { get; set; }
        
        public BookingStatus Status { get; set; } = BookingStatus.PendingPayment;
    }
}