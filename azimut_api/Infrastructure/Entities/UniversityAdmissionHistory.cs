using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities;

[Table("university_admission_history")]
public class UniversityAdmissionHistory : IEntity
{
    [Key, Column("id")] 
    public Guid Id { get; set; }
    [Column("university_program_id")] 
    public Guid UniversityProgramId { get; set; }
    [Column("admission_year")] 
    public short AdmissionYear { get; set; }

    [Required, MaxLength(64), Column("funding_type")]
    public required string FundingType { get; set; }

    [Required, MaxLength(64), Column("study_form")]
    public required string StudyForm { get; set; }

    [Required, MaxLength(100), Column("competition_category")]
    public required string CompetitionCategory { get; set; }

    [Column("passing_score")] 
    public short? PassingScore { get; set; }
    
    
    public UniversityProgram UniversityProgram { get; set; } = null!;
}