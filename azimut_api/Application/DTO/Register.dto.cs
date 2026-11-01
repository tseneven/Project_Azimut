using System.ComponentModel.DataAnnotations;
namespace Azimut.Application.DTO;
public class RegisterDTO
{
    [Required, EmailAddress, MaxLength(50)]
    public string Email { get; set; } = string.Empty;
    [Required]
    public string Password { get; set; } = string.Empty;
}
