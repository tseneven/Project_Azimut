using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities;

[Table("college_programs")]
public class CollegeProgram : IEntity
{
    [Key, Column("id")] public Guid Id { get; set; }
    [Column("institution_id")] public Guid InstitutionId { get; set; }
    public EducationalInstitution Institution { get; set; } = null!;
    [Required, MaxLength(500), Column("name")] public required string Name { get; set; }
    public ICollection<CollegeAdmissionHistory> AdmissionHistory { get; set; } = [];
}
