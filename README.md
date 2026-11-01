# Azimut authentication

The API contains auth endpoints, password helpers, JWT issuance and user persistence copied from Project Atlas. The Flutter project contains only Helpers, Configuration, ColorsApp, main, MaterialApp and a placeholder route.

## Local setup

1. Create a separate PostgreSQL database named azimut, then apply azimut_api/database/auth.sql.
2. Set ConnectionStrings__DefaultConnection to your database connection string (including password). Set Jwt__Key to a random secret of at least 32 bytes. Issuer and audience default to Azimut.
3. Run dotnet run --project azimut_api/azimut_api.csproj --launch-profile http.
4. In azimut_web run flutter run -d chrome --web-port 8080.

The API listens on http://localhost:5237. Override the frontend API with --dart-define=API_BASE_URL=https://your-api-host. Configure Cors__Origins__0 when using a different frontend origin.

Endpoints: POST /api/Auth/register and POST /api/Auth/login, with JSON email and password. Login returns token, userId and loginResult. Send Authorization: Bearer <token> to protected endpoints. Tokens expire after one hour.

The copied password format uses Atlas's salted SHA-256 scheme for compatibility. A future password-hashing upgrade should version stored hashes. No Atlas credentials, signing keys or user data were copied.

## Existing local Docker PostgreSQL

Azimut uses back-core-local-postgres-1 at localhost:15432, with its own azimut database and users table. The Atlas database is unchanged.

The full connection string and local JWT key are stored in .NET user secrets for azimut_api. The http launch profile selects Development, so the API loads these automatically.

Start the database with: docker start back-core-local-postgres-1
Start the API with: dotnet run --project azimut_api/azimut_api.csproj --launch-profile http

Direct Debug executable launches default to Development, load local user secrets and use http://localhost:5237. Explicit environment settings override this default. Release builds retain normal ASP.NET configuration behavior.

