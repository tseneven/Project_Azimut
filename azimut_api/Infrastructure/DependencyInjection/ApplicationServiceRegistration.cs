using Azimut.Infrastructure.Migration;
using Microsoft.EntityFrameworkCore;

namespace Azimut.Infrastructure.DependencyInjection;

public static class ApplicationServiceRegistration
{
    public static IServiceCollection AddApplicationServices(
        this IServiceCollection services, IConfiguration configuration)
    {
        services.AddHttpClient();
        services.AddDbContext<ApplicationContext>(options => options.UseNpgsql(
            configuration.GetConnectionString("DefaultConnection")));
        services.AddScopedDependencies();
        return services;
    }
}
