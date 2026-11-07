using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Azimut.Infrastructure.Entities;

[Table("miccedu_city_regions")]
public class MicceduCityRegion
{
    [Key, Column("city_id")] public Guid CityId { get; set; }
    public City City { get; set; } = null!;
    [Column("region_id")] public int RegionId { get; set; }
}
