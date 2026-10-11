param(
    [ValidateSet('ProductService','PricingService','PolicyService','PolicySearchService','PaymentService','DocumentService','AuthService','ChatService','DashboardService')]
    [string]$Service = 'ProductService'
)
$ports = @{ ProductService=5030; PricingService=5040; PolicyService=5050; PolicySearchService=5065; PaymentService=5070; DocumentService=5080; AuthService=6060; ChatService=4099; DashboardService=5035 }
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$project = Join-Path $root "src/$Service/$Service/$Service.csproj"
& dotnet run --project $project --no-launch-profile --urls "http://localhost:$($ports[$Service])"
exit $LASTEXITCODE

