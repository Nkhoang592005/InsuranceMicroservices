using System.Text.Json;
using MediatR;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.DependencyInjection;

namespace DashboardService.Test;

public class EnvironmentTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> factory;
    public EnvironmentTests(WebApplicationFactory<Program> factory) => this.factory = factory;

    [Fact]
    public async Task HostStartsWithMediatRAndReportsServiceHealth()
    {
        using var client = factory.CreateClient();
        using var response = await client.GetAsync("/health");
        response.EnsureSuccessStatusCode();
        using var body = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.Equal("DashboardService", body.RootElement.GetProperty("service").GetString());
        Assert.Equal("healthy", body.RootElement.GetProperty("status").GetString());
        using var scope = factory.Services.CreateScope();
        Assert.NotNull(scope.ServiceProvider.GetRequiredService<ISender>());
    }
}

