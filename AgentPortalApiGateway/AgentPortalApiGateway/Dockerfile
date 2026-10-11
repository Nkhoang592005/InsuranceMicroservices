FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY AgentPortalApiGateway/AgentPortalApiGateway/ ./
RUN dotnet publish AgentPortalApiGateway.csproj -c Release -o /app/publish
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8099
ENV ASPNETCORE_ENVIRONMENT=docker
COPY --from=build /app/publish .
EXPOSE 8099
ENTRYPOINT ["dotnet", "AgentPortalApiGateway.dll"]
