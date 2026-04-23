namespace CSharpService;

public static class EnvConfig
{
    public static string? ReadFromDotenv(string key)
    {
        if (!File.Exists(".env")) return null;
        foreach (var line in File.ReadAllLines(".env"))
        {
            var trimmed = line.Trim();
            if (trimmed.StartsWith('#') || !trimmed.Contains('=')) continue;
            var idx = trimmed.IndexOf('=');
            var k = trimmed[..idx].Trim();
            var v = trimmed[(idx + 1)..].Trim();
            if (k == key) return v;
        }
        return null;
    }

    public static string ResolveConfig(string key, string fallback)
    {
        return ReadFromDotenv(key)
            ?? Environment.GetEnvironmentVariable(key)
            ?? fallback;
    }

    public static int Add(int a, int b) => a + b;
}
