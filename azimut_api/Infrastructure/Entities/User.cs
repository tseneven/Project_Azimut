using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities;

[Table("users")]
public class User : IEntity
{
    [Key, Column("id")] 
    public Guid Id { get; set; }

    [Required, MaxLength(32), Column("type")]
    public string Type { get; set; } = "applicant";

    [MaxLength(100), Column("last_name")] 
    public string? LastName { get; set; }
    [MaxLength(100), Column("first_name")] 
    public string? FirstName { get; set; }

    [MaxLength(100), Column("middle_name")]
    public string? MiddleName { get; set; }

    [Column("birth_date")] 
    public DateOnly? BirthDate { get; set; }
    [Column("city_id")] 
    public Guid? CityId { get; set; }
    [MaxLength(32), Column("phone")] 
    public string? Phone { get; set; }

    [Required, MaxLength(254), Column("email")]
    public required string Email { get; set; }

    [Required, MaxLength(100), Column("hash_password")]
    public required string HashPassword { get; set; }

    [Required, MaxLength(100), Column("salt")]
    public required string Salt { get; set; }

    [Column("created_at")] 
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    [Column("updated_at")] 
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;
    
    public City? City { get; set; }
}