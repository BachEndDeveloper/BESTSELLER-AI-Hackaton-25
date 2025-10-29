# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy solution and project files
COPY BestsellerApi.sln ./
COPY BestsellerApi.ApiService/BestsellerApi.ApiService.csproj BestsellerApi.ApiService/
COPY BestsellerApi.ServiceDefaults/BestsellerApi.ServiceDefaults.csproj BestsellerApi.ServiceDefaults/

# Restore dependencies - use --disable-parallel for better stability
RUN dotnet restore BestsellerApi.ApiService/BestsellerApi.ApiService.csproj --disable-parallel

# Copy remaining source code
COPY BestsellerApi.ApiService/ BestsellerApi.ApiService/
COPY BestsellerApi.ServiceDefaults/ BestsellerApi.ServiceDefaults/

# Build the application
WORKDIR /src/BestsellerApi.ApiService
RUN dotnet build BestsellerApi.ApiService.csproj -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish BestsellerApi.ApiService.csproj -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy published files from publish stage
COPY --from=publish /app/publish .

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port (ASP.NET Core default port)
EXPOSE 8080

# Set environment variables
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Start the application
ENTRYPOINT ["dotnet", "BestsellerApi.ApiService.dll"]
