# BESTSELLER Semantic Kernel Demo - Java Spring Boot

This is a simple demo application that showcases how to use **Microsoft Semantic Kernel** with **Azure OpenAI** in a Java Spring Boot application. The demo demonstrates kernel function calling through plugins for item information, stock availability, and shipment tracking.

## 🎯 What This Demo Shows

1. **Semantic Kernel Setup**: How to configure and initialize Semantic Kernel with Azure OpenAI
2. **Plugin Creation**: How to create plugins with kernel functions
3. **Function Calling**: How to invoke kernel functions directly
4. **AI Integration**: How to use kernel functions with AI chat completion (optional, requires Azure OpenAI)

## 📋 Prerequisites

- **Java 17** or higher
- **Maven 3.8+**
- **(Optional)** Azure OpenAI account with a deployed model (e.g., GPT-4)

## 🚀 Quick Start

### 1. Clone and Navigate

```bash
cd demo/java
```

### 2. Configure Azure OpenAI (Optional)

If you want to test the AI chat functionality, edit `src/main/resources/application.yml` and replace the placeholder values:

```yaml
azure:
  openai:
    endpoint: https://your-resource-name.openai.azure.com
    api-key: your-actual-api-key
    deployment-name: your-deployment-name
```

**Note**: The demo works without Azure OpenAI credentials - you can still invoke kernel functions directly using the REST API.

### 3. Build the Application

```bash
mvn clean package
```

### 4. Run the Application

```bash
mvn spring-boot:run
```

The application will start on `http://localhost:8080`.

## 📚 API Endpoints

### Get Demo Information

Get information about available plugins and functions:

```bash
curl http://localhost:8080/api/demo/info
```

### Invoke Kernel Functions Directly

The demo shows how to call kernel functions directly without AI:

#### Get Item Information

```bash
curl "http://localhost:8080/api/demo/function/ItemPlugin/getItemInfo?parameter=item-001"
```

Response:
```json
{
  "plugin": "ItemPlugin",
  "function": "getItemInfo",
  "parameter": "item-001",
  "result": "Item ID: item-001, Name: Classic T-Shirt, Price: $29.99, Category: Apparel, Description: A comfortable cotton t-shirt perfect for everyday wear"
}
```

#### Check Stock Availability

```bash
curl "http://localhost:8080/api/demo/function/StockPlugin/checkAvailability?parameter=item-002"
```

#### Get Tracking Information

```bash
curl "http://localhost:8080/api/demo/function/TrackingPlugin/getTrackingInfo?parameter=TRK-2025-001"
```

### Chat with AI (Requires Azure OpenAI)

If you have configured Azure OpenAI, you can use the chat endpoint where the AI will automatically call the appropriate kernel functions:

```bash
curl -X POST http://localhost:8080/api/demo/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Tell me about item-001 and if it is in stock"}'
```

The AI will automatically invoke the `getItemInfo` and `checkAvailability` functions to answer your question.

## 🔧 Available Plugins and Functions

### ItemPlugin

- **getItemInfo**: Get detailed information about a product
  - Parameter: `itemId` (e.g., "item-001", "item-002", "item-003")
  
- **searchItemsByCategory**: Search for items by category
  - Parameter: `category` (e.g., "Apparel", "Footwear")

### StockPlugin

- **getStockInfo**: Get stock information for an item
  - Parameter: `itemId` (e.g., "item-001", "item-002", "item-003")
  
- **checkAvailability**: Check if an item is available for purchase
  - Parameter: `itemId` (e.g., "item-001", "item-002", "item-003")

### TrackingPlugin

- **getTrackingInfo**: Get tracking information for a shipment
  - Parameter: `trackingNo` (e.g., "TRK-2025-001", "TRK-2025-002")
  
- **getDeliveryStatus**: Get delivery status for a shipment
  - Parameter: `trackingNo` (e.g., "TRK-2025-001", "TRK-2025-002")

## 📦 Demo Data

The demo includes static data for demonstration purposes:

### Items
- **item-001**: Classic T-Shirt ($29.99) - Apparel
- **item-002**: Denim Jeans ($79.99) - Apparel
- **item-003**: Running Shoes ($129.99) - Footwear

### Stock Information
- **item-001**: In stock, 150 units
- **item-002**: In stock, 75 units
- **item-003**: Out of stock, 0 units

### Tracking Numbers
- **TRK-2025-001**: In Transit to Copenhagen
- **TRK-2025-002**: Delivered

## 🏗️ Project Structure

```
src/
├── main/
│   ├── java/com/bestseller/demo/
│   │   ├── SemanticKernelDemoApplication.java  # Main application class
│   │   ├── config/
│   │   │   └── SemanticKernelConfig.java       # Kernel configuration
│   │   ├── controller/
│   │   │   └── DemoController.java             # REST API endpoints
│   │   ├── data/
│   │   │   └── DemoDataStore.java              # Static demo data
│   │   ├── model/
│   │   │   ├── ItemInfo.java                   # Item model
│   │   │   ├── StockInfo.java                  # Stock model
│   │   │   └── TrackingInfo.java               # Tracking model
│   │   ├── plugin/
│   │   │   ├── ItemPlugin.java                 # Item kernel functions
│   │   │   ├── StockPlugin.java                # Stock kernel functions
│   │   │   └── TrackingPlugin.java             # Tracking kernel functions
│   │   └── service/
│   │       └── SemanticKernelService.java      # Kernel orchestration
│   └── resources/
│       └── application.yml                      # Application configuration
└── test/
    └── java/                                    # Test files (to be added)
```

## 💡 Key Concepts Demonstrated

### 1. Kernel Configuration

See `SemanticKernelConfig.java` - shows how to:
- Configure Azure OpenAI connection
- Create a Kernel instance
- Register the chat completion service

### 2. Plugin Creation

See the `plugin/` package - shows how to:
- Use `@DefineKernelFunction` annotation
- Use `@KernelFunctionParameter` for function parameters
- Provide semantic descriptions for AI understanding
- Return data that the AI can use

### 3. Function Invocation

See `SemanticKernelService.java` - shows how to:
- Register plugins with the kernel
- Invoke functions directly using `kernel.getFunction()`
- Pass arguments to functions
- Get results from function execution

### 4. AI Integration

See the `chat()` method in `SemanticKernelService.java` - shows how to:
- Create a chat history
- Configure prompt execution settings
- Enable automatic function calling
- Process user queries with AI

## 🔍 How Semantic Kernel Works

1. **Plugins**: Java classes with methods annotated as kernel functions
2. **Functions**: Methods that the AI can discover and call
3. **Kernel**: Orchestrates the execution of functions and AI services
4. **Automatic Function Calling**: The AI decides which functions to call based on user input

## 🛠️ Development

### Build

```bash
mvn clean compile
```

### Run Tests

```bash
mvn test
```

### Package

```bash
mvn clean package
```

The JAR file will be created in `target/semantic-kernel-demo-1.0.0.jar`.

### Run the JAR

```bash
java -jar target/semantic-kernel-demo-1.0.0.jar
```

## 📝 Notes

- This demo uses **static in-memory data** for simplicity
- Azure OpenAI configuration is **optional** - kernel functions work without it
- In a production application, you would:
  - Connect to a real database
  - Implement proper error handling
  - Add authentication and authorization
  - Use environment variables for secrets
  - Add comprehensive tests
  - Implement logging and monitoring

## 🔗 Resources

- [Microsoft Semantic Kernel Documentation](https://learn.microsoft.com/en-us/semantic-kernel/)
- [Semantic Kernel Java SDK on GitHub](https://github.com/microsoft/semantic-kernel-java)
- [Azure OpenAI Service Documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
- [Spring Boot Documentation](https://docs.spring.io/spring-boot/)

## 🤝 Contributing

This is a demo project for the BESTSELLER AI Hackathon 2025. Feel free to extend and modify it for your needs!

## 📄 License

See the main repository LICENSE file for licensing information.
