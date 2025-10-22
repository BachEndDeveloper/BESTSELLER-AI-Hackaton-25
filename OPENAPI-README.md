# OpenAPI 3.1 Specification

This directory contains the OpenAPI 3.1 specification for the BESTSELLER API.

## File

- **`openapi.yaml`** - Complete OpenAPI 3.1 specification file

## API Overview

The specification defines the following API endpoints:

### Items API
- **GET /items** - Retrieve a list of all items with basic information (itemId, name, price)
- **GET /items/{itemId}** - Retrieve detailed information about a specific item including full description

### Stock API
- **GET /stock/{itemId}** - Check stock availability for a specific item, including in-stock status and quantity

### Track API
- **GET /track/{trackingNo}** - Get the tracking status and history for a shipment using its tracking number

## Using the Specification

### Viewing the Specification

You can view and interact with the OpenAPI specification using several tools:

#### 1. Swagger UI (Online)
Visit [Swagger Editor](https://editor.swagger.io/) and paste the contents of `openapi.yaml` to view an interactive API documentation.

#### 2. Swagger UI (Local with Docker)
```bash
docker run -p 8080:8080 -e SWAGGER_JSON=/openapi.yaml -v $(pwd)/openapi.yaml:/openapi.yaml swaggerapi/swagger-ui
```
Then open http://localhost:8080 in your browser.

#### 3. ReDoc (Online)
Use [ReDoc online demo](https://redocly.github.io/redoc/) with the YAML file.

#### 4. VS Code Extensions
- Install the "OpenAPI (Swagger) Editor" extension
- Open the `openapi.yaml` file to view with syntax highlighting and validation

### Validating the Specification

#### Using Python
```bash
pip install openapi-spec-validator
openapi-spec-validator openapi.yaml
```

#### Using NPM
```bash
npm install -g @apidevtools/swagger-cli
swagger-cli validate openapi.yaml
```

### Generating Code

You can generate client SDKs or server stubs from this specification:

#### Generate Client SDK
```bash
# Install OpenAPI Generator
npm install -g @openapitools/openapi-generator-cli

# Generate Python client
openapi-generator-cli generate -i openapi.yaml -g python -o ./generated/python-client

# Generate Java client
openapi-generator-cli generate -i openapi.yaml -g java -o ./generated/java-client

# Generate TypeScript/JavaScript client
openapi-generator-cli generate -i openapi.yaml -g typescript-fetch -o ./generated/typescript-client
```

#### Generate Server Stub
```bash
# Generate Python FastAPI server
openapi-generator-cli generate -i openapi.yaml -g python-fastapi -o ./generated/fastapi-server

# Generate Spring Boot server
openapi-generator-cli generate -i openapi.yaml -g spring -o ./generated/spring-server

# Generate .NET server
openapi-generator-cli generate -i openapi.yaml -g aspnetcore -o ./generated/aspnetcore-server
```

## API Details

### Request/Response Format

All API endpoints use JSON format for requests and responses.

### Base URLs

The specification includes three server environments:
- **Production**: `https://api.bestseller.com/v1`
- **Staging**: `https://staging-api.bestseller.com/v1`
- **Local Development**: `http://localhost:8080/v1`

### Response Schemas

#### ItemSummary
```json
{
  "itemId": "string",
  "name": "string",
  "price": 29.99
}
```

#### ItemDetail
```json
{
  "itemId": "string",
  "name": "string",
  "price": 29.99,
  "description": "Full item description...",
  "category": "string",
  "brand": "string",
  "sku": "string"
}
```

#### StockInfo
```json
{
  "itemId": "string",
  "inStock": true,
  "quantity": 150,
  "warehouse": "string",
  "lastUpdated": "2025-10-22T06:00:00Z"
}
```

#### TrackingInfo
```json
{
  "trackingNo": "string",
  "status": "In Transit",
  "currentLocation": "string",
  "estimatedDelivery": "2025-10-25T18:00:00Z",
  "history": [
    {
      "timestamp": "2025-10-22T08:00:00Z",
      "location": "string",
      "status": "string",
      "description": "string"
    }
  ]
}
```

### Error Handling

All endpoints return standard error responses in the following format:

```json
{
  "code": 404,
  "message": "Resource not found",
  "details": "Additional error details"
}
```

## Implementation Notes

- All GET endpoints return JSON responses
- Path parameters are required where specified (e.g., `{itemId}`, `{trackingNo}`)
- Response codes:
  - `200` - Successful request
  - `404` - Resource not found
  - `500` - Internal server error
- Examples are provided for all endpoints to demonstrate expected request/response formats

## Support

For questions or issues with the API specification, please contact:
- **Email**: support@bestseller.com
- **Name**: BESTSELLER API Support

## License

See the main repository LICENSE file for licensing information.
