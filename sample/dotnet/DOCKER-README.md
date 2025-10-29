# Docker Setup for BESTSELLER API (.NET)

This directory contains Docker configuration for containerizing the BESTSELLER API .NET application.

## Files

- **Dockerfile** - Multi-stage Dockerfile for building and running the API
- **.dockerignore** - Specifies files/directories to exclude from the Docker build context

## Building the Docker Image

### Prerequisites

- Docker installed and running
- Internet connection (for downloading base images and NuGet packages)

### Build Command

From the `sample/dotnet` directory, run:

```bash
docker build -t bestseller-api:latest .
```

### Build Arguments

The Dockerfile uses a multi-stage build process:

1. **Build stage**: Uses `mcr.microsoft.com/dotnet/sdk:9.0` to restore dependencies, build, and publish the application
2. **Runtime stage**: Uses `mcr.microsoft.com/dotnet/aspnet:9.0` for a smaller final image

### Build Options

You can customize the build with tags:

```bash
# Build with a specific tag
docker build -t bestseller-api:v1.0.0 .

# Build with multiple tags
docker build -t bestseller-api:latest -t bestseller-api:v1.0.0 .
```

## Running the Container

### Basic Run

```bash
docker run -p 8080:8080 bestseller-api:latest
```

The API will be available at `http://localhost:8080`.

### Run with Environment Variables

```bash
docker run -p 8080:8080 \
  -e ConnectionStrings__postgres="Host=host.docker.internal;Port=5432;Database=ai-demo;Username=postgres;Password=postgres" \
  bestseller-api:latest
```

**Note**: Use `host.docker.internal` to access services running on the Docker host (like a local PostgreSQL instance).

### Run with Docker Compose

You can use Docker Compose to run the API with PostgreSQL:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: ai-demo
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ../../scripts:/docker-entrypoint-initdb.d

  api:
    build: .
    ports:
      - "8080:8080"
    environment:
      ConnectionStrings__postgres: "Host=postgres;Port=5432;Database=ai-demo;Username=postgres;Password=postgres"
    depends_on:
      - postgres

volumes:
  postgres-data:
```

Save this as `docker-compose.yml` and run:

```bash
docker-compose up
```

## Container Configuration

### Ports

- **8080**: HTTP port for the API

### Environment Variables

- `ASPNETCORE_URLS`: Set to `http://+:8080` by default
- `ASPNETCORE_ENVIRONMENT`: Set to `Production` by default
- `ConnectionStrings__postgres`: Database connection string (must be provided)

### User

The container runs as a non-root user (`appuser`) for security.

### Working Directory

The application runs from `/app` inside the container.

## Testing the Container

After starting the container, test the API endpoints:

```bash
# Get all items
curl http://localhost:8080/v1/items

# Get specific item
curl http://localhost:8080/v1/items/item-001

# Get stock information
curl http://localhost:8080/v1/stock/item-001

# Get tracking information
curl http://localhost:8080/v1/track/TRK-2025-000001
```

## Troubleshooting

### NuGet SSL Certificate Errors

If you encounter SSL certificate errors during `dotnet restore` in the Docker build:

1. **Temporary workaround**: Add the following to the Dockerfile before the restore command:
   ```dockerfile
   ENV DOTNET_SYSTEM_NET_HTTP_USESOCKETSHTTPHANDLER=0
   ```

2. **Alternative**: Use a local NuGet cache by mounting it as a volume during build:
   ```bash
   docker build --build-arg NUGET_PACKAGES=/nuget -v ${HOME}/.nuget/packages:/nuget -t bestseller-api:latest .
   ```

### Database Connection Issues

If the container can't connect to the database:

1. Verify PostgreSQL is running and accessible
2. Use `host.docker.internal` instead of `localhost` in the connection string when running on Docker Desktop
3. Ensure the database `ai-demo` exists and is initialized with the schema from `../../scripts/`
4. Check network connectivity between containers if using Docker Compose

### Port Already in Use

If port 8080 is already in use:

```bash
# Use a different host port
docker run -p 9090:8080 bestseller-api:latest

# Then access at http://localhost:9090
```

### Container Exits Immediately

Check the logs:

```bash
docker logs <container-id>
```

Common causes:
- Missing database connection string
- Database not accessible
- Application startup errors

## Image Size Optimization

The multi-stage build already optimizes the image size:

- Build artifacts are left in the build stage
- Only the published application is copied to the final runtime image
- Runtime image uses the smaller ASP.NET Core runtime (not the full SDK)

Typical image size: ~220 MB (runtime image only)

## Security Considerations

- Container runs as non-root user (`appuser`)
- Only necessary files are copied to the final image
- No development dependencies in the production image
- Secrets should be provided via environment variables or secret management systems (not hardcoded)

## Production Deployment

For production deployments, consider:

1. **Using a container registry**:
   ```bash
   docker tag bestseller-api:latest myregistry.azurecr.io/bestseller-api:v1.0.0
   docker push myregistry.azurecr.io/bestseller-api:v1.0.0
   ```

2. **Health checks**: Add health check endpoints and configure container orchestration to use them

3. **Resource limits**: Set CPU and memory limits appropriate for your workload

4. **Logging**: Configure centralized logging to collect container logs

5. **Monitoring**: Use OpenTelemetry integration for metrics and tracing

6. **Secrets management**: Use Azure Key Vault, AWS Secrets Manager, or Kubernetes secrets instead of environment variables

## Differences from Aspire Development

When running in Docker vs. using .NET Aspire for development:

- **No Aspire Dashboard**: The container runs the API only, without the Aspire orchestration
- **Manual PostgreSQL setup**: You need to provide your own PostgreSQL instance
- **Health endpoints disabled**: Health check endpoints are only available in Development mode
- **No service discovery**: Container uses direct connection strings instead of Aspire service discovery

For development, continue using `.NET Aspire` with the AppHost. Use Docker for:
- Production deployments
- CI/CD pipelines
- Testing in production-like environments
- Deployment to container orchestration platforms (Kubernetes, Azure Container Apps, etc.)

## Additional Resources

- [.NET Docker Samples](https://github.com/dotnet/dotnet-docker/tree/main/samples)
- [ASP.NET Core Docker Documentation](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/docker/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [.NET Aspire Documentation](https://learn.microsoft.com/dotnet/aspire/)
