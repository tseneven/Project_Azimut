using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities;

[Table("institution_advertisements")]
public class InstitutionAdvertisement : IEntity
{
    [Key, Column("id")] 
    public Guid Id { get; set; }
    [Column("institution_id")] 
    public Guid InstitutionId { get; set; }
    [Column("starts_at")] 
    public DateTimeOffset StartsAt { get; set; }
    [Column("expires_at")] 
    public DateTimeOffset ExpiresAt { get; set; }
    
    public EducationalInstitution Institution { get; set; } = null!;
}
