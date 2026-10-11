using MediatR;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssemblyContaining<Program>());
var app = builder.Build();
app.MapGet("/health", () => Results.Ok(new { service = "DashboardService", status = "healthy" }));
// Initial environment setup only; business handlers belong in this implementation project.
app.Run();
public partial class Program { }
