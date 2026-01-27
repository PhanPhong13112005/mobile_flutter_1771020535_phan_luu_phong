using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models
{
    public enum TransactionType { Deposit, Withdraw, Payment, Refund, Reward }
    public enum TransactionStatus { Pending, Completed, Rejected, Failed }

    [Table("535_WalletTransactions")]
    public class WalletTransaction
    {
        [Key]
        public int Id { get; set; }

        public int MemberId { get; set; }
        [ForeignKey("MemberId")]
        public Member? Member { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal Amount { get; set; } // + cho nạp/thưởng, - cho thanh toán

        public TransactionType Type { get; set; }
        public TransactionStatus Status { get; set; }

        public string? RelatedId { get; set; } // ID của Booking hoặc Tournament
        public string? Description { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.Now;
    }
}