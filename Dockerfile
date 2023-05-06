FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Test-Project-DevOps.csproj", "Test-Project-DevOps/"]
COPY ["Program.cs", "Test-Project-DevOps/"]
RUN dotnet restore "Test-Project-DevOps/Test-Project-DevOps.csproj"
COPY . .
WORKDIR "/src/Test-Project-DevOps"
RUN dotnet build "Test-Project-DevOps.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Test-Project-DevOps.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["./Test-Project-DevOps"]
