using System.ComponentModel.DataAnnotations;
namespace Azimut.Application.DTO;
public class LoginDTO
{
    [Required, EmailAddress, MaxLength(254)]
    public string Email { get; set; } = string.Empty;
    [Required]
    public string Password { get; set; } = string.Empty;
}

