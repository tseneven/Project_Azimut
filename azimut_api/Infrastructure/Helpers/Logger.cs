namespace Azimut.Infrastructure.Helpers;

public static class Logger
{
    public static void Success(string message)
    {
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine($"[SUCCESS в {DateTime.Now}] {message}");
        Console.ResetColor();
    }    
    
    public static void Warn(string message, Exception? ex = null)
    {
        Console.ForegroundColor = ConsoleColor.Yellow;
        if(ex != null)
            Console.WriteLine($"[Warn в {DateTime.Now}] {message}\n{ex.Message}: {ex}");
        else
            Console.WriteLine($"[Warn в {DateTime.Now}] {message}");
        Console.ResetColor();
    }    
    
    public static void Error(string message, Exception ex)
    {
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine($"[Error в {DateTime.Now}] {message}\n{ex.Message}: {ex}");
        Console.ResetColor();
    }
}
