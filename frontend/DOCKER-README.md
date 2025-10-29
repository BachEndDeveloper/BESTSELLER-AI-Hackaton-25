# Frontend Docker Setup

This directory contains the Dockerfile for the BESTSELLER frontend application.

## Building the Docker Image

There are two approaches to building the Docker image:

### Approach 1: Multi-stage Build (Recommended for CI/CD)

This builds everything inside Docker:

```bash
docker build -t bestseller-frontend .
```

**Note:** If you encounter npm installation issues in Docker (particularly in environments with proxy/certificate issues), use Approach 2.

### Approach 2: Pre-built Dist (Local Development)

If npm install fails in Docker, you can build locally first:

```bash
# Build the application locally
npm install
npm run build

# Build Docker image with pre-built dist
docker build -f Dockerfile.simple -t bestseller-frontend .
```

## Running the Container

```bash
docker run -d -p 8080:80 bestseller-frontend
```

The application will be available at `http://localhost:8080`

## Configuration

###  Environment Variables

The frontend can be configured using environment variables at build time:

- `VITE_API_BASE_URL`: Base URL for the API (default: http://localhost:8080/v1)

To set during build:

```bash
docker build --build-arg VITE_API_BASE_URL=https://api.example.com/v1 -t bestseller-frontend .
```

## Nginx Configuration

The included `nginx.conf` provides:
- SPA routing support (all routes serve index.html)
- Gzip compression
- Static asset caching
- Security headers

## Troubleshooting

### npm install fails in Docker

This can happen due to:
- Network/proxy issues
- Self-signed certificates
- npm bugs with signal handlers in Docker

**Solution**: Use Dockerfile.simple and build locally first.

### Permission issues

If you encounter permission issues when running the container:

```bash
docker run --user nginx -d -p 8080:80 bestseller-frontend
```
