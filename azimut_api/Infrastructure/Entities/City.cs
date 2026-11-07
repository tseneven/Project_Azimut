using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities;

[Table("cities")]
public class City : IEntity
{
    [Key, Column("id")] public Guid Id { get; set; }
    [Required, MaxLength(200), Column("name")] public required string Name { get; set; }
    public ICollection<User> Users { get; set; } = [];
    public ICollection<EducationalInstitution> Institutions { get; set; } = [];
}
