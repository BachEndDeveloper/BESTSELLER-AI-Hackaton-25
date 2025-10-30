# Quick Start Guide

This guide will help you get the BESTSELLER Semantic Kernel Demo up and running in minutes.

## Prerequisites

- Java 17 or higher
- Maven 3.8+

## Quick Start (Without Azure OpenAI)

You can run this demo without Azure OpenAI credentials to explore kernel function calling:

1. **Navigate to the demo directory:**
   ```bash
   cd demo/java
   ```

2. **Build the project:**
   ```bash
   mvn clean package
   ```

3. **Run the application:**
   ```bash
   mvn spring-boot:run
   ```

4. **Test the endpoints:**

   Get information about available functions:
   ```bash
   curl http://localhost:8080/api/demo/info
   ```

   Get item information:
   ```bash
   curl "http://localhost:8080/api/demo/function/ItemPlugin/getItemInfo?parameter=item-001"
   ```

   Check stock availability:
   ```bash
   curl "http://localhost:8080/api/demo/function/StockPlugin/checkAvailability?parameter=item-002"
   ```

   Get tracking information:
   ```bash
   curl "http://localhost:8080/api/demo/function/TrackingPlugin/getTrackingInfo?parameter=TRK-2025-001"
   ```

## With Azure OpenAI (Optional)

To enable AI chat functionality:

1. **Edit `src/main/resources/application.yml`:**
   ```yaml
   azure:
     openai:
       endpoint: https://your-resource-name.openai.azure.com
       api-key: your-actual-api-key
       deployment-name: your-deployment-name
   ```

2. **Run the application and try the chat endpoint:**
   ```bash
   curl -X POST http://localhost:8080/api/demo/chat \
     -H "Content-Type: application/json" \
     -d '{"message": "Tell me about item-001 and if it is in stock"}'
   ```

## Available Demo Data

### Items
- `item-001`: Classic T-Shirt ($29.99)
- `item-002`: Denim Jeans ($79.99)
- `item-003`: Running Shoes ($129.99)

### Tracking Numbers
- `TRK-2025-001`: In Transit
- `TRK-2025-002`: Delivered

## Troubleshooting

### Port 8080 already in use
Run on a different port:
```bash
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8081
```

Then use port 8081 in your curl commands.

### Build fails
Clean and rebuild:
```bash
mvn clean compile
```

## Next Steps

- Explore the code in `src/main/java/com/bestseller/demo/`
- Learn how plugins are created in the `plugin/` package
- See how the kernel is configured in `config/SemanticKernelConfig.java`
- Check out the full README.md for detailed information
