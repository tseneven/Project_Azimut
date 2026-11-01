using Azimut.Infrastructure.Entities;
using Microsoft.EntityFrameworkCore;

namespace Azimut.Infrastructure.Migration;

public class ApplicationContext(DbContextOptions<ApplicationContext> options) : DbContext(options)
{
    public DbSet<User> Users { get; set; }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>().HasIndex(user => user.Email).IsUnique();
    }
}
