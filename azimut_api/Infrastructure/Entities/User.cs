using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities
{
    [Table("users")]
    public class User : IEntity
    {
        [Key]
        [Column("user_id")]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("email")]
        public required string Email { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("hash_password")]
        public required string HashPassword { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("salt")]
        public required string Salt { get; set; }
        

    }
}


