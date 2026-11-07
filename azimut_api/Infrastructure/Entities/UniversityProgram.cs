using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities;

[Table("university_programs")]
public class UniversityProgram : IEntity
{
    [Key, Column("id")] 
    public Guid Id { get; set; }
    [Column("institution_id")]
    public Guid InstitutionId { get; set; }
    [Required, MaxLength(500), Column("name")] 
    public required string Name { get; set; }
    public ICollection<UniversityAdmissionHistory> AdmissionHistory { get; set; } = [];
    public EducationalInstitution Institution { get; set; } = null!;
}
