using Azimut.Infrastructure.Entities;
using Microsoft.EntityFrameworkCore;

namespace Azimut.Infrastructure.Migration;

public class ApplicationContext(DbContextOptions<ApplicationContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();
    public DbSet<City> Cities => Set<City>();
    public DbSet<MicceduCityRegion> MicceduCityRegions => Set<MicceduCityRegion>();
    public DbSet<EducationalInstitution> Institutions => Set<EducationalInstitution>();
    public DbSet<InstitutionAdvertisement> Advertisements => Set<InstitutionAdvertisement>();
    public DbSet<UniversityProgram> UniversityPrograms => Set<UniversityProgram>();
    public DbSet<CollegeProgram> CollegePrograms => Set<CollegeProgram>();
    public DbSet<UniversityAdmissionHistory> UniversityAdmissionHistory => Set<UniversityAdmissionHistory>();
    public DbSet<CollegeAdmissionHistory> CollegeAdmissionHistory => Set<CollegeAdmissionHistory>();

    protected override void OnModelCreating(ModelBuilder model)
    {
        model.Entity<User>().HasKey(x => x.Id).HasName("users_pkey");
        model.Entity<User>().HasIndex(x => x.Email).IsUnique();
        model.Entity<User>().HasOne(x => x.City).WithMany(x => x.Users).HasForeignKey(x => x.CityId);
        model.Entity<User>().Property(x => x.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
        model.Entity<User>().Property(x => x.UpdatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
        model.Entity<City>().HasIndex(x => new { x.Name }).IsUnique();
        model.Entity<MicceduCityRegion>().HasOne(x => x.City)
            .WithOne().HasForeignKey<MicceduCityRegion>(x => x.CityId);
        model.Entity<MicceduCityRegion>().ToTable(t =>
            t.HasCheckConstraint("ck_miccedu_city_regions_region_id", "region_id > 0"));
        model.Entity<EducationalInstitution>().HasOne(x => x.City)
            .WithMany(x => x.Institutions).HasForeignKey(x => x.CityId);
        model.Entity<EducationalInstitution>().HasOne(x => x.ParentInstitution)
            .WithMany(x => x.Branches).HasForeignKey(x => x.ParentInstitutionId);
        model.Entity<EducationalInstitution>().HasIndex(x => new { x.CityId, x.Name });
        model.Entity<UniversityProgram>().HasOne(x => x.Institution)
            .WithMany(x => x.UniversityPrograms).HasForeignKey(x => x.InstitutionId);
        model.Entity<CollegeProgram>().HasOne(x => x.Institution)
            .WithMany(x => x.CollegePrograms).HasForeignKey(x => x.InstitutionId);
        model.Entity<InstitutionAdvertisement>().HasOne(x => x.Institution)
            .WithMany(x => x.Advertisements).HasForeignKey(x => x.InstitutionId);
        model.Entity<InstitutionAdvertisement>().HasIndex(x => new { x.StartsAt, x.ExpiresAt });
        model.Entity<UniversityAdmissionHistory>().HasOne(x => x.UniversityProgram)
            .WithMany(x => x.AdmissionHistory).HasForeignKey(x => x.UniversityProgramId);
        model.Entity<CollegeAdmissionHistory>().HasOne(x => x.CollegeProgram)
            .WithMany(x => x.AdmissionHistory).HasForeignKey(x => x.CollegeProgramId);
        model.Entity<UniversityAdmissionHistory>().HasIndex(x => new {
            x.UniversityProgramId, x.AdmissionYear, x.FundingType, x.StudyForm, x.CompetitionCategory
        }).IsUnique();
        model.Entity<CollegeAdmissionHistory>().HasIndex(x => new {
            x.CollegeProgramId, x.AdmissionYear, x.FundingType, x.StudyForm, x.EntryGrade
        }).IsUnique();

        foreach (var entity in model.Model.GetEntityTypes())
        {
            if (typeof(IEntity).IsAssignableFrom(entity.ClrType))
                model.Entity(entity.ClrType).Property(nameof(IEntity.Id)).HasDefaultValueSql("gen_random_uuid()");
            foreach (var foreignKey in entity.GetForeignKeys())
                foreignKey.DeleteBehavior = DeleteBehavior.Restrict;
        }

        model.Entity<City>().ToTable(t => t.HasCheckConstraint("ck_city_country", "length(country_code) = 2"));
        model.Entity<EducationalInstitution>().ToTable(t => {
            t.HasCheckConstraint("ck_institution_type", "type IN ('university', 'college')");
            t.HasCheckConstraint("ck_institution_parent", "parent_institution_id IS NULL OR parent_institution_id <> id");
        });
        model.Entity<InstitutionAdvertisement>().ToTable(t =>
            t.HasCheckConstraint("ck_advertisement_dates", "expires_at > starts_at"));
        model.Entity<UniversityAdmissionHistory>().ToTable(t => {
            t.HasCheckConstraint("ck_university_year", "admission_year BETWEEN 2000 AND 2200");
            t.HasCheckConstraint("ck_university_score", "passing_score IS NULL OR passing_score >= 0");
        });
        model.Entity<CollegeAdmissionHistory>().ToTable(t => {
            t.HasCheckConstraint("ck_college_year", "admission_year BETWEEN 2000 AND 2200");
            t.HasCheckConstraint("ck_college_grade", "entry_grade IN (9, 11)");
        });
    }

    private void UpdateUserTimestamps()
    {
        var now = DateTimeOffset.UtcNow;
        foreach (var entry in ChangeTracker.Entries<User>())
        {
            if (entry.State == EntityState.Added) entry.Entity.CreatedAt = now;
            if (entry.State is EntityState.Added or EntityState.Modified) entry.Entity.UpdatedAt = now;
        }
    }

    public override int SaveChanges(bool acceptAllChangesOnSuccess)
    {
        UpdateUserTimestamps();
        return base.SaveChanges(acceptAllChangesOnSuccess);
    }

    public override Task<int> SaveChangesAsync(bool acceptAllChangesOnSuccess, CancellationToken cancellationToken = default)
    {
        UpdateUserTimestamps();
        return base.SaveChangesAsync(acceptAllChangesOnSuccess, cancellationToken);
    }
}
