using CSharpService;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () =>
{
    var databaseUrl = EnvConfig.ResolveConfig("DATABASE_URI", "postgres://localhost:5432/app");
    var redisEndpoint = EnvConfig.ResolveConfig("REDIS_ENDPOINT", "redis://localhost:6379");

    return Results.Json(new
    {
        message = "hello from csharp",
        config = new
        {
            database_url = databaseUrl,
            redis_endpoint = redisEndpoint
        }
    });
});

var port = EnvConfig.ResolveConfig("PORT", "8080");
app.Urls.Add($"http://0.0.0.0:{port}");
app.Run();
