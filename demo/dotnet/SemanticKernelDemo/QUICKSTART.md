# Semantic Kernel Demo - Quick Start Guide

## What Was Created

A complete, production-ready demonstration of Microsoft Semantic Kernel integrated with Azure OpenAI, showcasing best practices for building AI-powered .NET applications.

## Files Created

```
demo/dotnet/SemanticKernelDemo/
├── Program.cs                      # Main application with 6 interactive demos
├── SemanticKernelDemo.csproj       # Project file with dependencies
├── README.md                       # Comprehensive documentation
├── .editorconfig                   # Code formatting rules
├── .gitignore                      # Exclude build artifacts and secrets
└── appsettings.example.json        # Configuration template
```

## Quick Start (3 Steps)

### 1. Configure Azure OpenAI

```bash
cd demo/dotnet/SemanticKernelDemo

# Set your Azure OpenAI credentials
dotnet user-secrets set "AzureOpenAI:Endpoint" "https://your-resource.openai.azure.com/"
dotnet user-secrets set "AzureOpenAI:ApiKey" "your-api-key"
dotnet user-secrets set "AzureOpenAI:DeploymentName" "gpt-4o"
```

### 2. Build

```bash
dotnet build
```

### 3. Run

```bash
dotnet run
```

## What You'll See

An interactive menu with 6 demos:

1. **Simple Chat Completion** - Basic AI conversations
2. **Conversation with History** - Multi-turn chats with context
3. **Streaming Response** - Real-time token streaming
4. **Semantic Function** - Prompt templates for product descriptions
5. **Plugin Usage** - Custom ProductPlugin with catalog functions
6. **Auto-function Calling** - AI automatically using plugins

## Example Interactions

### Demo 1: Simple Chat
```
Enter your message: What is Semantic Kernel?
🤖 Assistant: Semantic Kernel is an open-source SDK from Microsoft...
```

### Demo 5: Plugin Usage
```
📦 Available Products:
- item-001: Classic T-Shirt ($29.99) - Stock: 150
- item-002: Slim Fit Jeans ($79.99) - Stock: 75
...

Enter a product ID: item-001
📊 Stock Status: Classic T-Shirt is IN STOCK with 150 units available
```

### Demo 6: Auto-function Calling
```
Enter your question: Is item-001 in stock?
🤖 Assistant: Yes! The Classic T-Shirt is IN STOCK with 150 units available at $29.99
```

## Technology Stack

- **.NET 9.0** - Latest .NET with modern C# features
- **Semantic Kernel 1.66.0** - Latest SK SDK
- **Azure OpenAI** - Enterprise-grade AI models

## Key Features Demonstrated

### Configuration Management
- User Secrets for secure local development
- Environment variables for production
- Configuration validation with helpful error messages

### Semantic Kernel Patterns
- Kernel initialization and service registration
- Chat completion service usage
- Chat history management
- Streaming responses
- Prompt templates with variables
- Custom plugin creation
- Auto-function calling

### Best Practices
- Async/await throughout
- Nullable reference types enabled
- Proper error handling
- Clear user feedback
- XML documentation
- Clean code structure

## ProductPlugin Functions

The demo includes a custom plugin with realistic product data:

1. **GetProducts()** - Lists all available products
2. **CheckStock(productId)** - Checks availability for a specific item
3. **GetProductDetails(productId)** - Gets detailed product information

The plugin demonstrates:
- `[KernelFunction]` attribute usage
- Function descriptions for AI
- Parameter descriptions for better AI understanding
- Structured return values

## Learning Path

1. **Read the code** - Program.cs is well-documented
2. **Try each demo** - Experience different SK features
3. **Modify prompts** - Experiment with prompt templates
4. **Add functions** - Extend the ProductPlugin
5. **Build your own** - Create custom plugins for your domain

## Next Steps

- Add more plugins (weather, orders, customers)
- Implement persistent storage
- Add RAG with embeddings
- Deploy to Azure
- Integrate with existing systems

## Documentation

For detailed information, see:
- `README.md` - Complete documentation
- `Program.cs` - Source code with XML comments
- [Semantic Kernel Docs](https://learn.microsoft.com/semantic-kernel/)

## Support

Questions? Check:
- README.md for troubleshooting
- Semantic Kernel documentation
- Azure OpenAI documentation

---

**You now have a complete, working Semantic Kernel demo!** 🚀
