using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities;

[Table("college_admission_history")]
public class CollegeAdmissionHistory : IEntity
{
    [Key, Column("id")] public Guid Id { get; set; }
    [Column("college_program_id")] public Guid CollegeProgramId { get; set; }
    public CollegeProgram CollegeProgram { get; set; } = null!;
    [Column("admission_year")] public short AdmissionYear { get; set; }
    [Required, MaxLength(64), Column("funding_type")] public required string FundingType { get; set; }
    [Required, MaxLength(64), Column("study_form")] public required string StudyForm { get; set; }
    [Column("entry_grade")] public short EntryGrade { get; set; }
}
