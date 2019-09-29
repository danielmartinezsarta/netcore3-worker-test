FROM mcr.microsoft.com/dotnet/core/runtime:3.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["worker-service.csproj", "./"]
RUN dotnet restore "./worker-service.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "worker-service.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "worker-service.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "worker-service.dll"]
