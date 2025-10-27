# BESTSELLER API - .NET Aspire Sample

A comprehensive .NET Aspire application implementing the BESTSELLER OpenAPI specification. This application provides a REST API for managing items, stock, and tracking information with cloud-ready distributed architecture.

## Features

- **.NET Aspire**: Cloud-ready distributed application orchestration
- **Minimal APIs**: Modern ASP.NET Core minimal API approach
- **PostgreSQL**: Database with EF Core for data access
- **REST API**: Implements all endpoints from the OpenAPI specification
- **Error Handling**: Standardized error responses with ProblemDetails
- **Observability**: Built-in OpenTelemetry support via Aspire ServiceDefaults
- **Health Checks**: Automatic health endpoints
- **Service Discovery**: Built-in service discovery and resilience

## Technology Stack

- **.NET 9.0**: Latest .NET version
- **.NET Aspire 8.2.2**: Cloud-ready distributed application framework
- **ASP.NET Core**: Minimal API framework
- **Entity Framework Core 9.0**: ORM for data access
- **Npgsql 9.0.2**: PostgreSQL provider
- **PostgreSQL**: Relational database

## Prerequisites

- .NET 9.0 SDK or higher
- Docker (for running PostgreSQL via Aspire)
- .NET Aspire workload installed:
  ```bash
  dotnet workload install aspire
  ```

## Project Structure

```
sample/dotnet/
├── BestsellerApi.AppHost/           # Aspire orchestration host
│   └── Program.cs                    # Configures PostgreSQL and API service
├── BestsellerApi.ApiService/        # REST API implementation
│   ├── Data/                         # DbContext
│   ├── Entities/                     # Database entities
│   ├── Models/                       # API DTOs
│   └── Program.cs                    # API endpoints
├── BestsellerApi.ServiceDefaults/   # Shared configuration
│   └── Extensions.cs                 # OpenTelemetry, resilience, service discovery
└── BestsellerApi.sln                # Solution file
```

## Getting Started

### 1. Clone and Navigate

```bash
cd sample/dotnet
```

### 2. Restore Dependencies

```bash
dotnet restore
```

### 3. Build the Solution

```bash
dotnet build
```

### 4. Run with Aspire

The recommended way to run the application is using the Aspire AppHost, which will automatically:
- Start a PostgreSQL container with pgAdmin
- Configure the database connection
- Start the API service
- Provide an Aspire dashboard for monitoring

```bash
dotnet run --project BestsellerApi.AppHost
```

After running, you'll see URLs in the console:
- **Aspire Dashboard**: `http://localhost:15xxx` - Monitor services, logs, traces
- **API Service**: `http://localhost:5xxx` - The API endpoints
- **pgAdmin**: `http://localhost:5xxx` - Database administration

> **Note**: Aspire will create a PostgreSQL container automatically. The database will be empty initially. You need to run the database scripts from the `../../scripts/` directory to populate it with demo data.

### 5. Set Up Database (First Time Only)

Once the PostgreSQL container is running, you need to populate it with the schema and demo data:

```bash
# Get the PostgreSQL container name from Aspire dashboard or docker ps
docker ps | grep postgres

# Run the database scripts
cd ../../scripts

# Create tables (skip database creation as Aspire creates it)
docker exec -i <container-name> psql -U postgres -d ai-demo < 02_create_items_table.sql
docker exec -i <container-name> psql -U postgres -d ai-demo < 03_create_stock_table.sql
docker exec -i <container-name> psql -U postgres -d ai-demo < 04_create_tracking_table.sql
docker exec -i <container-name> psql -U postgres -d ai-demo < 05_insert_demo_data.sql
```

Alternatively, you can use pgAdmin (available in Aspire dashboard) to run the scripts manually.

### Alternative: Run API Service Standalone

You can also run just the API service if you have PostgreSQL running separately:

```bash
# Ensure PostgreSQL is running on localhost:5432 with database 'ai-demo'
dotnet run --project BestsellerApi.ApiService
```

Update `appsettings.json` with your PostgreSQL connection string if needed:

```json
{
  "ConnectionStrings": {
    "postgres": "Host=localhost;Port=5432;Database=ai-demo;Username=postgres;Password=postgres"
  }
}
```

## API Endpoints

The application implements the following endpoints according to the OpenAPI specification:

### Items

- **GET /v1/items** - Get all items (returns ItemSummary list)
  ```bash
  curl http://localhost:5000/v1/items
  ```

- **GET /v1/items/{itemId}** - Get item details
  ```bash
  curl http://localhost:5000/v1/items/item-001
  ```

### Stock

- **GET /v1/stock/{itemId}** - Get stock information for an item
  ```bash
  curl http://localhost:5000/v1/stock/item-001
  ```

### Tracking

- **GET /v1/track/{trackingNo}** - Get tracking status and history
  ```bash
  curl http://localhost:5000/v1/track/TRK-2025-000001
  ```

> **Note**: Replace `localhost:5000` with the actual port shown in the Aspire dashboard or console output.

## Configuration

### Connection Strings

The application uses the Aspire-managed connection string by default. For standalone mode, configure in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "postgres": "Host=localhost;Port=5432;Database=ai-demo;Username=postgres;Password=postgres"
  }
}
```

### Environment Variables

You can also configure via environment variables:

```bash
export ConnectionStrings__postgres="Host=localhost;Port=5432;Database=ai-demo;Username=postgres;Password=postgres"
```

## Response Examples

### ItemSummary (GET /v1/items)
```json
[
  {
    "itemId": "item-001",
    "name": "Classic T-Shirt",
    "price": 29.99
  }
]
```

### ItemDetail (GET /v1/items/{itemId})
```json
{
  "itemId": "item-001",
  "name": "Classic T-Shirt",
  "price": 29.99,
  "description": "A comfortable cotton t-shirt perfect for everyday wear...",
  "category": "Apparel",
  "brand": "BESTSELLER",
  "sku": "BST-TS-001"
}
```

### StockInfo (GET /v1/stock/{itemId})
```json
{
  "itemId": "item-001",
  "inStock": true,
  "quantity": 150,
  "warehouse": "Main Warehouse",
  "lastUpdated": "2025-10-22T06:00:00Z"
}
```

### TrackingInfo (GET /v1/track/{trackingNo})
```json
{
  "trackingNo": "TRK-2025-000001",
  "status": "In Transit",
  "currentLocation": "Distribution Center - Copenhagen",
  "estimatedDelivery": "2025-10-25T18:00:00Z",
  "deliveryDate": null,
  "history": [
    {
      "timestamp": "2025-10-22T08:00:00Z",
      "location": "Distribution Center - Copenhagen",
      "status": "In Transit",
      "description": "Package is on its way"
    }
  ]
}
```

## Error Responses

All errors follow the standard ProblemDetails format:

```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.4",
  "title": "Resource not found",
  "status": 404,
  "detail": "Item not found: item-999"
}
```

Error codes:
- `404` - Resource not found (item, stock, or tracking number)
- `500` - Internal server error

## Aspire Dashboard

The Aspire dashboard provides comprehensive monitoring:

- **Resources**: View all running services and their status
- **Console Logs**: Real-time logs from all services
- **Structured Logs**: Filterable structured logging
- **Traces**: Distributed tracing with OpenTelemetry
- **Metrics**: Performance metrics and health checks

Access the dashboard at the URL shown when running the AppHost (typically `http://localhost:15xxx`).

## Development

### Running Locally with Hot Reload

```bash
dotnet watch --project BestsellerApi.ApiService
```

### Code Formatting

```bash
dotnet format
```

### Building for Production

```bash
dotnet publish BestsellerApi.ApiService -c Release -o ./publish
```

## Code Quality

The codebase follows .NET best practices:

- **Nullable Reference Types**: Enabled for all projects
- **Minimal APIs**: Modern endpoint routing
- **Records**: Immutable DTOs for API models
- **EF Core**: Proper entity configuration and relationships
- **Async/Await**: Non-blocking database operations
- **Dependency Injection**: Constructor injection throughout
- **Logging**: Structured logging ready for OpenTelemetry
- **Error Handling**: ProblemDetails for standardized errors

## Testing

### Manual Testing with curl

```bash
# Get all items
curl -v http://localhost:5000/v1/items

# Get specific item
curl -v http://localhost:5000/v1/items/item-001

# Get stock for item
curl -v http://localhost:5000/v1/stock/item-001

# Get tracking information
curl -v http://localhost:5000/v1/track/TRK-2025-000001

# Test 404 error
curl -v http://localhost:5000/v1/items/non-existent-item
```

### Using the Included HTTP File

Visual Studio and JetBrains Rider support `.http` files. Use `BestsellerApi.ApiService.http` for quick testing.

## Troubleshooting

### Aspire Dashboard Not Opening

Ensure you have the Aspire workload installed:
```bash
dotnet workload list
dotnet workload install aspire
```

### Database Connection Issues

1. Check if PostgreSQL container is running via Aspire dashboard
2. Verify database name is `ai-demo`
3. Check connection string in Aspire environment variables

### Port Conflicts

Aspire automatically assigns available ports. Check the console output or Aspire dashboard for actual URLs.

### Docker Issues

Aspire requires Docker to be running. Ensure Docker Desktop or Docker daemon is active:
```bash
docker ps
```

## OpenAPI Specification

This implementation conforms to the OpenAPI 3.1 specification located at `../../openapi.yaml`. All endpoints, request/response formats, and error codes match the specification.

## License

See the main repository LICENSE file for licensing information.

## Support

For questions or issues:
- Review the OpenAPI specification: `../../openapi.yaml`
- Check database scripts: `../../scripts/`
- Consult .NET Aspire documentation: https://learn.microsoft.com/dotnet/aspire/
- Consult ASP.NET Core documentation: https://learn.microsoft.com/aspnet/core/

## Next Steps

Potential enhancements:
- Add comprehensive unit and integration tests
- Implement request validation with FluentValidation
- Add Swagger/OpenAPI UI for interactive documentation
- Implement caching with distributed cache
- Add authentication and authorization
- Integrate AI features using Microsoft Semantic Kernel
- Add more comprehensive observability with custom metrics
