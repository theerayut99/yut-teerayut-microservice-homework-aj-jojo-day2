using CSharpService;
using Xunit;

namespace CSharpService.Tests;

public class ServiceTests
{
    [Fact]
    public void Add_ReturnsCorrectSum()
    {
        Assert.Equal(3, EnvConfig.Add(1, 2));
    }

    [Fact]
    public void ResolveConfig_ReturnsFallback_WhenKeyAbsent()
    {
        var result = EnvConfig.ResolveConfig("__NO_SUCH_KEY__", "default-value");
        Assert.Equal("default-value", result);
    }

    [Fact]
    public void ResolveConfig_ReturnsEnvVar_WhenSet()
    {
        Environment.SetEnvironmentVariable("__TEST_KEY__", "from-env");
        var result = EnvConfig.ResolveConfig("__TEST_KEY__", "fallback");
        Environment.SetEnvironmentVariable("__TEST_KEY__", null);
        Assert.Equal("from-env", result);
    }
}
