# Frontend Docker Setup

This directory contains the Dockerfile for the BESTSELLER frontend application.

## Quick Start

### Building the Docker Image

```bash
cd frontend
docker build -t bestseller-frontend .
```

### Running the Container

```bash
docker run -d -p 8080:80 bestseller-frontend
```

The application will be available at `http://localhost:8080`

## Docker Image Details

The Dockerfile uses a multi-stage build approach:

1. **Builder Stage** (node:20-alpine): Installs dependencies and builds the React application
2. **Production Stage** (nginx:alpine): Serves the built static files with nginx

### Image Size

- Final image size: ~45MB (nginx:alpine + built static files)
- Builder stage is discarded, keeping the production image small

## Configuration

### API Base URL

The frontend can be configured to point to different API endpoints using environment variables:

```bash
# During build time
docker build --build-arg VITE_API_BASE_URL=https://api.example.com/v1 -t bestseller-frontend .
```

Or create a `.env` file in the frontend directory before building:

```env
VITE_API_BASE_URL=https://api.example.com/v1
```

## Nginx Configuration

The included `nginx.conf` provides:

- **SPA Routing**: All routes serve `index.html` for client-side routing
- **Gzip Compression**: Reduces payload size for faster loading
- **Static Asset Caching**: 1-year cache for immutable assets (JS, CSS, images)
- **Security Headers**: X-Frame-Options, X-Content-Type-Options, X-XSS-Protection

### Custom Nginx Configuration

To modify the nginx configuration, edit `nginx.conf` and rebuild the image.

## Development vs Production

### Local Development

For local development without Docker:

```bash
npm install
npm run dev
```

### Production Build

The Dockerfile automatically creates a production-optimized build with:
- Minified JavaScript and CSS
- Tree-shaking to remove unused code
- Asset optimization

## Troubleshooting

### Build Fails with npm Errors

If you encounter npm install issues in Docker environments with network restrictions:

**Symptoms:**
```
npm error Exit handler never called!
npm error This is an error with npm itself.
```

**Solutions:**

1. **Check network/proxy settings:** Ensure Docker can access npm registry
2. **Use local build:** Build the app locally first:
   ```bash
   npm run build
   # Then create a simple Dockerfile that just copies dist/
   ```

3. **Check npm registry mirror:** Configure npm to use a different registry:
   ```bash
   docker build --build-arg NPM_CONFIG_REGISTRY=https://registry.npmmirror.com -t bestseller-frontend .
   ```

### Container Doesn't Start

Check container logs:
```bash
docker logs <container-id>
```

Common issues:
- Port 80 already in use: Use a different port mapping `-p 8080:80`
- Permission issues: nginx user needs read access to `/usr/share/nginx/html`

### Application Not Accessible

1. Verify container is running:
   ```bash
   docker ps | grep bestseller-frontend
   ```

2. Check port mapping:
   ```bash
   docker port <container-id>
   ```

3. Test nginx is serving files:
   ```bash
   docker exec <container-id> ls -la /usr/share/nginx/html
   ```

## Advanced Usage

### Multi-architecture Builds

To build for multiple architectures (e.g., ARM64 for Apple Silicon):

```bash
# Build and load for local use
docker buildx build --platform linux/amd64,linux/arm64 -t bestseller-frontend --load .

# Or build and push to a registry
docker buildx build --platform linux/amd64,linux/arm64 -t your-registry/bestseller-frontend --push .
```

### Docker Compose

Example `docker-compose.yml`:

```yaml
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "8080:80"
    environment:
      - VITE_API_BASE_URL=http://api:8080/v1
    depends_on:
      - api
```

### Health Checks

Add a health check to your docker run command:

```bash
docker run -d \
  --health-cmd="wget --no-verbose --tries=1 --spider http://localhost/ || exit 1" \
  --health-interval=30s \
  --health-timeout=3s \
  --health-retries=3 \
  -p 8080:80 \
  bestseller-frontend
```

## Security Considerations

1. **No sensitive data in image**: Never include API keys or secrets in the Docker image
2. **Use environment variables**: Configure sensitive settings at runtime
3. **Keep base images updated**: Regularly rebuild with latest nginx:alpine
4. **Run as non-root**: nginx:alpine runs as the nginx user by default

## Additional Resources

- [Vite Docker Deployment](https://vitejs.dev/guide/static-deploy.html)
- [Nginx Docker Official Image](https://hub.docker.com/_/nginx)
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
