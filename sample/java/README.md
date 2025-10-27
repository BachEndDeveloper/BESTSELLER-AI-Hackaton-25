# BESTSELLER API - Java Spring Boot Sample

A comprehensive Spring Boot application implementing the BESTSELLER OpenAPI specification. This application provides a reactive REST API for managing items, stock, and tracking information.

## Features

- **Reactive Architecture**: Built with Spring WebFlux and R2DBC for non-blocking, asynchronous operations
- **REST API**: Implements all endpoints from the OpenAPI specification
- **Database Integration**: PostgreSQL database with R2DBC for reactive data access
- **Error Handling**: Global exception handling with standardized error responses
- **Health Checks**: Spring Boot Actuator for monitoring and health endpoints
- **Structured Logging**: SLF4J with contextual logging

## Technology Stack

- **Java 17**: LTS version with modern features (records, pattern matching)
- **Spring Boot 3.2.0**: Latest Spring Boot framework
- **Spring WebFlux**: Reactive web framework
- **Spring Data R2DBC**: Reactive relational database connectivity
- **PostgreSQL**: Database (with R2DBC driver)
- **Maven**: Build and dependency management

## Prerequisites

- Java 17 or higher
- Maven 3.8+
- PostgreSQL 12+ with the `ai-demo` database set up
- Docker (optional, for running PostgreSQL)

## Database Setup

Before running the application, you need to set up the PostgreSQL database. The database scripts are located in the `../../scripts/` directory.

### Option 1: Using existing PostgreSQL instance

```bash
# Navigate to the scripts directory
cd ../../scripts

# Run scripts in order
psql -U postgres -f 01_create_database.sql
psql -U postgres -d ai-demo -f 02_create_items_table.sql
psql -U postgres -d ai-demo -f 03_create_stock_table.sql
psql -U postgres -d ai-demo -f 04_create_tracking_table.sql
psql -U postgres -d ai-demo -f 05_insert_demo_data.sql
```

### Option 2: Using Docker

```bash
# Start PostgreSQL in Docker
docker run --name bestseller-postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=ai-demo \
  -p 5432:5432 \
  -d postgres:16

# Wait for PostgreSQL to start (about 5-10 seconds)
sleep 10

# Run database scripts
cd ../../scripts
for script in 02_create_items_table.sql 03_create_stock_table.sql 04_create_tracking_table.sql 05_insert_demo_data.sql; do
    docker exec -i bestseller-postgres psql -U postgres -d ai-demo < "$script"
done
```

## Configuration

The application can be configured via environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | PostgreSQL host | `localhost` |
| `DB_PORT` | PostgreSQL port | `5432` |
| `DB_NAME` | Database name | `ai-demo` |
| `DB_USER` | Database username | `postgres` |
| `DB_PASSWORD` | Database password | `postgres` |
| `SERVER_PORT` | Application server port | `8080` |

### Configuration File

You can also modify `src/main/resources/application.yml` directly.

## Building the Application

```bash
# Clean and compile
mvn clean compile

# Run tests (when available)
mvn test

# Package the application
mvn clean package

# Skip tests (only for quick builds)
mvn clean package -DskipTests
```

## Running the Application

### Using Maven

```bash
mvn spring-boot:run
```

### Using environment variables

```bash
DB_HOST=localhost DB_PORT=5432 DB_NAME=ai-demo DB_USER=postgres DB_PASSWORD=postgres mvn spring-boot:run
```

### Using packaged JAR

```bash
# Build the JAR
mvn clean package

# Run the JAR
java -jar target/bestseller-api-1.0.0.jar
```

## API Endpoints

The application implements the following endpoints according to the OpenAPI specification:

### Items

- **GET /v1/items** - Get all items (returns ItemSummary list)
  ```bash
  curl http://localhost:8080/v1/items
  ```

- **GET /v1/items/{itemId}** - Get item details
  ```bash
  curl http://localhost:8080/v1/items/item-001
  ```

### Stock

- **GET /v1/stock/{itemId}** - Get stock information for an item
  ```bash
  curl http://localhost:8080/v1/stock/item-001
  ```

### Tracking

- **GET /v1/track/{trackingNo}** - Get tracking status and history
  ```bash
  curl http://localhost:8080/v1/track/TRK-2025-001234
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
  "trackingNo": "TRK-2025-001234",
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

All errors follow a standard format:

```json
{
  "code": 404,
  "message": "Resource not found",
  "details": "Item not found: item-999"
}
```

Error codes:
- `404` - Resource not found (item or tracking number)
- `500` - Internal server error

## Health Checks

The application includes Spring Boot Actuator endpoints:

- **GET /actuator/health** - Application health status
  ```bash
  curl http://localhost:8080/actuator/health
  ```

- **GET /actuator/info** - Application information
  ```bash
  curl http://localhost:8080/actuator/info
  ```

- **GET /actuator/metrics** - Application metrics
  ```bash
  curl http://localhost:8080/actuator/metrics
  ```

## Project Structure

```
src/
├── main/
│   ├── java/com/bestseller/api/
│   │   ├── BestsellerApiApplication.java  # Main application class
│   │   ├── controller/                     # REST controllers
│   │   │   ├── ItemController.java
│   │   │   ├── StockController.java
│   │   │   └── TrackingController.java
│   │   ├── entity/                         # Database entities (R2DBC)
│   │   │   ├── Item.java
│   │   │   ├── Stock.java
│   │   │   ├── Tracking.java
│   │   │   └── TrackingEventEntity.java
│   │   ├── exception/                      # Custom exceptions
│   │   │   ├── GlobalExceptionHandler.java
│   │   │   ├── ItemNotFoundException.java
│   │   │   └── TrackingNotFoundException.java
│   │   ├── model/                          # API models (DTOs)
│   │   │   ├── ErrorResponse.java
│   │   │   ├── ItemDetail.java
│   │   │   ├── ItemSummary.java
│   │   │   ├── StockInfo.java
│   │   │   ├── TrackingEvent.java
│   │   │   └── TrackingInfo.java
│   │   ├── repository/                     # R2DBC repositories
│   │   │   ├── ItemRepository.java
│   │   │   ├── StockRepository.java
│   │   │   ├── TrackingEventRepository.java
│   │   │   └── TrackingRepository.java
│   │   └── service/                        # Business logic
│   │       ├── ItemService.java
│   │       ├── StockService.java
│   │       └── TrackingService.java
│   └── resources/
│       └── application.yml                 # Configuration
└── test/                                   # Tests (to be implemented)
```

## Code Quality

The codebase follows Spring Boot and Java best practices:

- **Reactive Programming**: Uses Mono and Flux for non-blocking operations
- **Constructor Injection**: All dependencies injected via constructor
- **Records**: Java records for immutable DTOs
- **Logging**: Structured logging with SLF4J
- **Error Handling**: Comprehensive exception handling
- **Code Style**: Follows .editorconfig standards (4-space indentation, 120 char line length)

## Development Tips

### Enable DEBUG logging

Edit `application.yml` and change:
```yaml
logging:
  level:
    com.bestseller.api: DEBUG
```

### Test with curl

```bash
# Get all items
curl -v http://localhost:8080/v1/items

# Get specific item
curl -v http://localhost:8080/v1/items/item-001

# Get stock for item
curl -v http://localhost:8080/v1/stock/item-001

# Get tracking information
curl -v http://localhost:8080/v1/track/TRK-2025-000001

# Test 404 error
curl -v http://localhost:8080/v1/items/non-existent-item
```

### Hot reload during development

Use Spring Boot DevTools (add to pom.xml):
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional>
</dependency>
```

## Troubleshooting

### Database connection issues

1. Ensure PostgreSQL is running:
   ```bash
   psql -U postgres -d ai-demo -c "SELECT 1"
   ```

2. Check database credentials in application.yml or environment variables

3. Verify the database and tables exist:
   ```bash
   psql -U postgres -d ai-demo -c "\dt"
   ```

### Port already in use

Change the server port:
```bash
SERVER_PORT=8081 mvn spring-boot:run
```

### Build errors

Clean Maven cache:
```bash
mvn clean
rm -rf ~/.m2/repository/com/bestseller
mvn clean install
```

## OpenAPI Specification

This implementation conforms to the OpenAPI 3.1 specification located at `../../openapi.yaml`. All endpoints, request/response formats, and error codes match the specification.

## License

See the main repository LICENSE file for licensing information.

## Support

For questions or issues:
- Review the OpenAPI specification: `../../openapi.yaml`
- Check database scripts: `../../scripts/`
- Consult Spring Boot documentation: https://docs.spring.io/spring-boot/

## Next Steps

Potential enhancements:
- Add comprehensive unit and integration tests
- Implement request validation with JSR-380 annotations
- Add API documentation with SpringDoc OpenAPI
- Implement caching with Spring Cache
- Add authentication and authorization with Spring Security
- Integrate AI features using Microsoft Semantic Kernel
- Add metrics and distributed tracing with OpenTelemetry
