using Azimut.Application.DTO;
using Azimut.Domain;
using Azimut.Infrastructure.DependencyInjection;
using Azimut.Infrastructure.Entities;
using Azimut.Infrastructure.Helpers;
using Azimut.Infrastructure.Services.Auth.Guards;

namespace Azimut.Infrastructure.Services.Auth
{
    public class AuthService(JwtService jwtService, EntityStorage entityStorage) : IScopedDependency
    {
        public async Task<RegisterResult> Register(RegisterDTO registerDTO)
        {
            try
            {
                var result = entityStorage.Select<User>().FirstOrDefault(u => u.Email == registerDTO.Email);

                if (result == null)
                {
                    var salt = PasswordHelper.GenerateSalt();
                    var saltString = Convert.ToBase64String(salt);
                    var hashPassword = PasswordHelper.HashPassword(registerDTO.Password, salt);
                    var hashPasswordString = Convert.ToBase64String(hashPassword);
                    User userDTO = new User()
                    {
                        Email = registerDTO.Email,
                        FirstName = registerDTO.FirstName?.Trim(),
                        Salt = saltString,
                        HashPassword = hashPasswordString,
                    };

                    await entityStorage.CreateAsync(userDTO);
                    return RegisterResult.Success;
                }

                return RegisterResult.AlreadyExists;
            }
            catch (Exception ex)
            {
                Logger.Error("Что-то пошло не так..", ex);
                return RegisterResult.Error;
            }
        }

        public AuthDTO Login(LoginDTO loginReq)
        {
            try
            {
                var userEntity = entityStorage.Select<User>().FirstOrDefault(u => u.Email == loginReq.Email);

                if (userEntity == null)
                    return new AuthDTO { LoginResult = LoginResult.NotFound };

                var userDTO = new UserDTO
                {
                    Id = userEntity.Id,
                    Email = userEntity.Email,
                    PasswordHash = userEntity.HashPassword,
                };

                var saltBytes = Convert.FromBase64String(userEntity.Salt);
                var hashPassword = PasswordHelper.HashPassword(loginReq.Password, saltBytes);
                var hashPasswordString = Convert.ToBase64String(hashPassword);

                if (userDTO.PasswordHash == hashPasswordString)
                {
                    var token = jwtService.GenerateToken(userDTO.Id.ToString(), userDTO.Email);
                    return new AuthDTO
                        { Token = token, UserId = userEntity.Id.ToString(), LoginResult = LoginResult.Success };
                }

                return new AuthDTO { LoginResult = LoginResult.InvalidPassword };
            }
            catch (Exception ex)
            {
                Logger.Error($"{loginReq.Email}: Что-то упало...", ex);
                return new AuthDTO { LoginResult = LoginResult.Unknown };
            }
        }
    }

    public class AuthDTO
    {
        public String? UserId { get; set; }
        public string? Token { get; set; }
        public LoginResult LoginResult { get; set; }
    }

    public enum RegisterResult
    {
        Error = 1,
        Success = 2,
        AlreadyExists = 3,
    }

    public enum LoginResult
    {
        Unknown,
        Success,
        NotFound,
        InvalidPassword,
    }
}
