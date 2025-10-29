# Docker Quick Start Guide

This guide provides a quick reference for using Docker with the BESTSELLER API .NET application.

## Prerequisites
- Docker and Docker Compose installed
- No .NET SDK required

## Quick Start (Recommended)

### Using Docker Compose

```bash
# Navigate to the dotnet sample directory
cd sample/dotnet

# Start the complete stack (PostgreSQL + API)
docker-compose up

# Access the API at http://localhost:8080
```

To stop:
```bash
docker-compose down
```

To stop and remove volumes (clean slate):
```bash
docker-compose down -v
```

## Manual Docker Commands

### Build the Image

```bash
docker build -t bestseller-api:latest .
```

### Run with External Database

```bash
docker run -p 8080:8080 \
  -e ConnectionStrings__postgres="Host=host.docker.internal;Port=5432;Database=ai-demo;Username=postgres;Password=postgres" \
  bestseller-api:latest
```

### View Logs

```bash
# Docker Compose
docker-compose logs -f api

# Standalone container
docker logs -f <container-id>
```

## Testing the API

Once running, test with curl:

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

## Common Issues

### Port Already in Use
Change the port mapping in docker-compose.yml or use a different port:
```bash
docker run -p 9090:8080 ...
```

### Database Connection Failed
Ensure PostgreSQL is running and accessible. Check connection string format.

### Build Fails
Check Docker is running and you have internet connectivity for downloading base images.

## For More Details

See [DOCKER-README.md](DOCKER-README.md) for:
- Detailed configuration options
- Troubleshooting guide
- Production deployment recommendations
- Security considerations

## Architecture

```
┌─────────────────────────────────────┐
│     Docker Compose Stack            │
├─────────────────────────────────────┤
│                                     │
│  ┌────────────────┐                │
│  │  PostgreSQL 16 │                │
│  │  Port: 5432    │                │
│  │  DB: ai-demo   │                │
│  └────────┬───────┘                │
│           │                         │
│  ┌────────▼───────────────────┐   │
│  │  BESTSELLER API            │   │
│  │  .NET 9.0                  │   │
│  │  Port: 8080                │   │
│  │  User: appuser (non-root)  │   │
│  └────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

## What Gets Created

### Containers
- `bestseller-postgres`: PostgreSQL 16 database
- `bestseller-api`: .NET API application

### Volumes
- `postgres-data`: Persistent database storage

### Networks
- Default bridge network for inter-container communication

## Clean Up

Remove everything:
```bash
# Stop and remove containers, networks
docker-compose down

# Also remove volumes (all data will be lost)
docker-compose down -v

# Remove the built image
docker rmi bestseller-api:latest
```

## Next Steps

1. Explore the API endpoints listed above
2. Check the main [README.md](README.md) for API documentation
3. Review [DOCKER-README.md](DOCKER-README.md) for advanced usage
4. See [../../openapi.yaml](../../openapi.yaml) for the complete API specification
