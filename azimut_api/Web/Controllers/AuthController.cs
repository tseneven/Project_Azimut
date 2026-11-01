using Azimut.Application.DTO;
using Azimut.Infrastructure.Helpers;
using Azimut.Infrastructure.Services.Auth;
using Microsoft.AspNetCore.Mvc;

namespace Azimut.Web.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AuthController(AuthService authService) : ControllerBase
{
    [HttpPost("login")]
    public IActionResult Login([FromBody] LoginDTO loginReq)
    {
        try
        {
            var token = authService.Login(loginReq);

            switch (token.LoginResult)
            {
                case LoginResult.NotFound:
                {
                    Logger.Warn($"Попытались авторизироваться на {loginReq.Email}, но таких незнаем");
                    return NotFound();
                }
                case LoginResult.InvalidPassword:
                {
                    Logger.Warn($"Попытались авторизироваться на {loginReq.Email}, а пароль-то неверный, проверЬ!");
                    return StatusCode(403);
                }
                case LoginResult.Unknown:
                    return StatusCode(500);
                case LoginResult.Success:
                    return Ok(token);
                default:
                    return StatusCode(500);
            }
        }
        catch (Exception ex)
        {
            Logger.Error("Упс... А не получилось авторизоваться", ex);
            return StatusCode(500, ex.Message);
        }
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterDTO registerDTO)
    {
        try
        {
            var result = await authService.Register(registerDTO);
            switch (result)
            {
                case RegisterResult.AlreadyExists:
                    Logger.Warn($"Такая запись уже есть");
                    return BadRequest();
                case RegisterResult.Error:
                    return StatusCode(500);
                case RegisterResult.Success:
                    return Ok(result);
                default:
                    return StatusCode(500);
            }
        }
        catch (Exception ex)
        {
            Logger.Error("Упс... А не зарегистрироваться не получилось", ex);
            return StatusCode(500, ex.Message);
        }
    }
}
