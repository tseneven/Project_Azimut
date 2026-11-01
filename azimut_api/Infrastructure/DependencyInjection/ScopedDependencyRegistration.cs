namespace Azimut.Infrastructure.DependencyInjection;

public static class ScopedDependencyRegistration
{
    public static IServiceCollection AddScopedDependencies(this IServiceCollection services)
    {
        services.Scan(scan => scan
            .FromAssemblyOf<IScopedDependency>()
            .AddClasses(classes => classes.AssignableTo<IScopedDependency>())
            .AsSelf()
            .WithScopedLifetime());
        return services;
    }
}

