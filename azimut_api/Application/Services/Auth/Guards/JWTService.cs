using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace Azimut.Infrastructure.Services.Auth.Guards;

public class JwtService : Azimut.Infrastructure.DependencyInjection.IScopedDependency
{
    private readonly string _secret;
    private readonly string _issuer;
    private readonly string _audience;

    public JwtService(IConfiguration configuration)
    {
        _secret = configuration["Jwt:Key"] ?? throw new InvalidOperationException("Configure Jwt:Key.");
        _issuer = configuration["Jwt:Issuer"] ?? throw new InvalidOperationException("Configure Jwt:Issuer.");
        _audience = configuration["Jwt:Audience"] ?? throw new InvalidOperationException("Configure Jwt:Audience.");
    }

    public string GenerateToken(string userId, string username)
    {
        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, userId),
            new Claim(JwtRegisteredClaimNames.UniqueName, username),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_secret));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _issuer,
            audience: _audience,
            claims: claims,
            expires: DateTime.UtcNow.AddHours(1),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}


