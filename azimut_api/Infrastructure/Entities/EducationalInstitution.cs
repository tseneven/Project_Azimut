using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities;

[Table("educational_institutions")]
public class EducationalInstitution : IEntity
{
    [Key, Column("id")] public Guid Id { get; set; }
    [Required, MaxLength(1000), Column("name")] public required string Name { get; set; }
    [Column("city_id")] public Guid CityId { get; set; }
    public City City { get; set; } = null!;
    [Column("parent_institution_id")] public Guid? ParentInstitutionId { get; set; }
    public EducationalInstitution? ParentInstitution { get; set; }
    [Required, MaxLength(32), Column("type")] public required string Type { get; set; }
    [MaxLength(2048), Column("website_url")] public string? WebsiteUrl { get; set; }
    [MaxLength(2048), Column("logo_url")] public string? LogoUrl { get; set; }
    [MaxLength(2048), Column("image_url")] public string? ImageUrl { get; set; }
    [MaxLength(1000), Column("address")] public string? Address { get; set; }
    [Column("description", TypeName = "text")] public string? Description { get; set; }
    public ICollection<EducationalInstitution> Branches { get; set; } = [];
    public ICollection<UniversityProgram> UniversityPrograms { get; set; } = [];
    public ICollection<CollegeProgram> CollegePrograms { get; set; } = [];
    public ICollection<InstitutionAdvertisement> Advertisements { get; set; } = [];
}
