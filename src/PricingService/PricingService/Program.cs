using MediatR;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssemblyContaining<Program>());

int port = 5040;
try {
    using var s = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
    s.Bind(new IPEndPoint(IPAddress.Loopback, 5040));
    s.Listen(1);
    s.Close();
} catch {
    port = 5042;
}
builder.WebHost.UseUrls($"http://localhost:{port}");
var app = builder.Build();

string instanceId = $"localhost:PricingService:{port}";
var eureka = new HttpClient { BaseAddress = new Uri("http://localhost:8761/") };
const string appName = "PRICINGSERVICE";

var instance = new Dictionary<string, object> {
    ["instanceId"] = instanceId,
    ["hostName"] = "localhost",
    ["app"] = appName,
    ["ipAddr"] = "127.0.0.1",
    ["status"] = "UP",
    ["port"] = new Dictionary<string, object> { ["$"] = port, ["@enabled"] = true },
    ["securePort"] = new Dictionary<string, object> { ["$"] = 443, ["@enabled"] = false },
    ["countryId"] = 1,
    ["dataCenterInfo"] = new Dictionary<string, object> { ["name"] = "MyOwn" },
    ["metadata"] = new Dictionary<string, object> { },
    ["homePageUrl"] = $"http://localhost:{port}/",
    ["statusPageUrl"] = $"http://localhost:{port}/info",
    ["healthCheckUrl"] = $"http://localhost:{port}/health",
    ["vipAddress"] = "PricingService",
    ["isCoordinatingDiscoveryServer"] = false
};
var registration = new { instance };

async Task<bool> RegisterEurekaAsync() {
    try {
        var json = JsonSerializer.Serialize(registration);
        using var content = new StringContent(json, Encoding.UTF8, "application/json");
        var res = await eureka.PostAsync($"eureka/apps/{appName}", content);
        Console.WriteLine($"[Eureka] register {appName}: {(int)res.StatusCode} {res.StatusCode}");
        return true;
    } catch (Exception ex) {
        Console.WriteLine($"[Eureka] register failed: {ex.Message}");
        return false;
    }
}

async Task<bool> HeartbeatEurekaAsync() {
    try {
        var encoded = WebUtility.UrlEncode(instanceId);
        var res = await eureka.PutAsync($"eureka/apps/{appName}/instance/{encoded}", null);
        return res.IsSuccessStatusCode;
    } catch { return false; }
}

app.MapGet("/health", () => Results.Ok(new { service = "PricingService", status = "healthy" }));
app.MapGet("/info", () => Results.Ok(new {
    service = "PricingService",
    description = "Insurance premium calculation",
    health = "/health"
}));

var cts = new CancellationTokenSource();
app.Lifetime.ApplicationStopping.Register(() => cts.Cancel());

await RegisterEurekaAsync();
await HeartbeatEurekaAsync();
_ = Task.Run(async () => {
    using var timer = new PeriodicTimer(TimeSpan.FromSeconds(30));
    while (await timer.WaitForNextTickAsync(cts.Token)) await HeartbeatEurekaAsync();
}, cts.Token);

app.Run();

try {
    var encoded = WebUtility.UrlEncode(instanceId);
    await eureka.DeleteAsync($"eureka/apps/{appName}/instance/{encoded}");
} catch { }

public partial class Program { }
