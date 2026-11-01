using Azimut.Infrastructure.Entities;
using Azimut.Infrastructure.Migration;
using Azimut.Infrastructure.DependencyInjection;

namespace Azimut.Infrastructure.Helpers;

public class EntityStorage(ApplicationContext context) : IScopedDependency
{
    public IQueryable<T> Select<T>() where T : class
    {
        try
        {
            return context.Set<T>();
        }
        catch (Exception e)
        {
            Logger.Error("Что-то сломалось при запросе в Postgres", e);
            throw;
        }
    }

    public async Task<int> CreateAsync<T>(T entity) where T : class, IEntity
    {
        try
        {
            context.Set<T>().Add(entity);
            await Commit();

            return entity.Id;
        }
        catch (Exception e)
        {
            Logger.Error("Что-то сломалось при создании записи в Postgres", e);
            throw;
        }
    }

    public async Task<T> CreateEntityAsync<T>(T entity) where T : class
    {
        try
        {
            context.Set<T>().Add(entity);
            await Commit();
            return entity;
        }
        catch (Exception e)
        {
            Logger.Error("Что-то сломалось при создании записи в Postgres", e);
            throw;
        }
    }

    public async Task UpdateAsync<T>(T entity)
        where T : class
    {
        try
        {
            context.Set<T>().Update(entity);
            await Commit();
        }
        catch (Exception e)
        {
            Logger.Error("Что-то сломалось при обновлении записи в Postgres", e);
            throw;
        }
    }

    public async Task DeleteAsync<T>(T entity)
        where T : class
    {
        try
        {
            context.Set<T>().Remove(entity);
            await Commit();
        }
        catch (Exception e)
        {
            Logger.Error("Что-то сломалось при удалении записи из Postgres", e);
            throw;
        }
    }


    private Task Commit() => context.SaveChangesAsync();
}

