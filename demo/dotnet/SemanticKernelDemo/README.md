# Semantic Kernel Demo - Azure OpenAI Integration

A comprehensive demonstration of **Microsoft Semantic Kernel** integration with **Azure OpenAI** using **.NET 9** and the latest Semantic Kernel SDK.

## 🎯 What This Demo Shows

This demo application showcases the core capabilities of Semantic Kernel:

1. **Simple Chat Completion** - Basic AI interactions with single messages
2. **Conversation with History** - Multi-turn conversations with context preservation
3. **Streaming Responses** - Real-time token streaming for better UX
4. **Semantic Functions** - Prompt templates with variable substitution
5. **Plugin Usage** - Extending Semantic Kernel with custom functionality
6. **Auto-function Calling** - AI automatically invoking plugins when needed

## 🛠️ Technology Stack

- **.NET 9.0** - Latest .NET version with modern C# features
- **Microsoft Semantic Kernel 1.66.0** - Latest Semantic Kernel SDK
- **Azure OpenAI** - Enterprise-grade OpenAI models via Azure
- **User Secrets** - Secure local configuration management

## 📋 Prerequisites

Before running this demo, ensure you have:

### Required Software
- **.NET 9 SDK** or higher
  ```bash
  dotnet --version  # Should show 9.0.x
  ```

### Azure OpenAI Resources
You need an Azure OpenAI resource with a deployed model:

1. **Azure OpenAI Service** instance
2. **Deployed Model** (e.g., GPT-4, GPT-4o, GPT-3.5-turbo)
3. **Endpoint URL** (format: `https://<your-resource>.openai.azure.com/`)
4. **API Key** (found in Azure Portal under "Keys and Endpoint")

If you don't have Azure OpenAI access:
- [Request access to Azure OpenAI](https://aka.ms/oai/access)
- [Azure OpenAI Documentation](https://learn.microsoft.com/azure/ai-services/openai/)

## 🚀 Getting Started

### 1. Clone and Navigate

```bash
cd demo/dotnet/SemanticKernelDemo
```

### 2. Configure Azure OpenAI Credentials

You have two options for configuration:

#### Option A: User Secrets (Recommended for Development)

User Secrets keep your credentials secure and out of source control:

```bash
# Initialize user secrets (already configured in .csproj)
dotnet user-secrets init

# Set your Azure OpenAI configuration
dotnet user-secrets set "AzureOpenAI:Endpoint" "https://your-resource.openai.azure.com/"
dotnet user-secrets set "AzureOpenAI:ApiKey" "your-api-key-here"
dotnet user-secrets set "AzureOpenAI:DeploymentName" "gpt-4o"
```

Replace the values with your actual Azure OpenAI details:
- **Endpoint**: Your Azure OpenAI resource endpoint
- **ApiKey**: Your API key from Azure Portal
- **DeploymentName**: The name of your deployed model (e.g., `gpt-4o`, `gpt-4`, `gpt-35-turbo`)

#### Option B: Environment Variables

Alternatively, use environment variables:

**Linux/macOS:**
```bash
export AzureOpenAI__Endpoint="https://your-resource.openai.azure.com/"
export AzureOpenAI__ApiKey="your-api-key-here"
export AzureOpenAI__DeploymentName="gpt-4o"
```

**Windows (PowerShell):**
```powershell
$env:AzureOpenAI__Endpoint="https://your-resource.openai.azure.com/"
$env:AzureOpenAI__ApiKey="your-api-key-here"
$env:AzureOpenAI__DeploymentName="gpt-4o"
```

**Windows (Command Prompt):**
```cmd
set AzureOpenAI__Endpoint=https://your-resource.openai.azure.com/
set AzureOpenAI__ApiKey=your-api-key-here
set AzureOpenAI__DeploymentName=gpt-4o
```

> **Note**: Environment variables use double underscores (`__`) instead of colons (`:`)

### 3. Restore Dependencies

```bash
dotnet restore
```

### 4. Build the Application

```bash
dotnet build
```

### 5. Run the Demo

```bash
dotnet run
```

You'll see a menu with six demo options. Select the number corresponding to the demo you want to try.

## 📚 Demo Details

### Demo 1: Simple Chat Completion

The most basic interaction - send a message, get a response.

**What it demonstrates:**
- Basic chat completion API usage
- Getting a service from the Kernel
- Handling single-turn conversations

**Example:**
```
You: What is Semantic Kernel?
AI: Semantic Kernel is an open-source SDK that helps developers...
```

### Demo 2: Conversation with History

Multi-turn conversation where the AI remembers previous messages.

**What it demonstrates:**
- Chat history management
- System messages for behavior control
- Context preservation across turns
- Adding user and assistant messages to history

**Example:**
```
You: I'm looking for a t-shirt
AI: I'd be happy to help you find a t-shirt...

You: What colors do you have?
AI: Based on our previous discussion about t-shirts...
```

### Demo 3: Streaming Response

Tokens arrive in real-time, like ChatGPT's typing effect.

**What it demonstrates:**
- Streaming API for real-time responses
- Async enumeration (`await foreach`)
- Better UX for long responses

**Example:**
```
AI: [Words appear one by one as they're generated]
```

### Demo 4: Semantic Function (Prompt Template)

Create reusable prompt templates with variable substitution.

**What it demonstrates:**
- Creating functions from prompts
- Template variable syntax (`{{$variableName}}`)
- Kernel arguments for parameter passing
- Structured prompt engineering

**Example:**
```
Input: "Classic T-Shirt"
Output: "Discover timeless style with our Classic T-Shirt, crafted from 
         premium cotton for all-day comfort..."
```

### Demo 5: Plugin Usage

Extend Semantic Kernel with custom C# functions.

**What it demonstrates:**
- Creating custom plugins
- Kernel function attributes
- Direct plugin invocation
- Plugin function parameters

**Features:**
- `GetProducts()` - Lists all products in catalog
- `CheckStock(productId)` - Checks availability
- `GetProductDetails(productId)` - Gets detailed info

### Demo 6: Auto-function Calling

The AI automatically decides when to call plugin functions.

**What it demonstrates:**
- Automatic function calling (function calling)
- AI reasoning about when to use tools
- OpenAI function choice behavior
- Natural language to function invocation

**Example:**
```
You: Is item-001 in stock?
AI: [Automatically calls CheckStock("item-001")]
    Yes! The Classic T-Shirt is IN STOCK with 150 units available at $29.99
```

## 🏗️ Code Structure

```
SemanticKernelDemo/
├── Program.cs                      # Main demo application
│   ├── Main()                      # Entry point, configuration, menu
│   ├── SimpleChatCompletionDemo()
│   ├── ConversationWithHistoryDemo()
│   ├── StreamingResponseDemo()
│   ├── SemanticFunctionDemo()
│   ├── PluginUsageDemo()
│   ├── AutoFunctionCallingDemo()
│   └── ProductPlugin                # Custom plugin class
├── SemanticKernelDemo.csproj       # Project file with dependencies
└── README.md                        # This file
```

## 🔑 Key Concepts

### Kernel

The `Kernel` is the central orchestrator in Semantic Kernel. It:
- Manages AI services (chat completion, embeddings, etc.)
- Hosts plugins and functions
- Handles execution context and configuration

```csharp
var builder = Kernel.CreateBuilder();
builder.AddAzureOpenAIChatCompletion(
    deploymentName: deploymentName,
    endpoint: endpoint,
    apiKey: apiKey);
var kernel = builder.Build();
```

### Chat Completion Service

Provides access to AI chat capabilities:

```csharp
var chatService = kernel.GetRequiredService<IChatCompletionService>();
var response = await chatService.GetChatMessageContentAsync("Hello!");
```

### Chat History

Maintains conversation context:

```csharp
var history = new ChatHistory();
history.AddSystemMessage("You are a helpful assistant");
history.AddUserMessage("Hello");
history.AddAssistantMessage("Hi there!");
```

### Semantic Functions

Reusable prompt templates:

```csharp
var prompt = "Translate to {{$language}}: {{$text}}";
var function = kernel.CreateFunctionFromPrompt(prompt);
var result = await kernel.InvokeAsync(function, new KernelArguments
{
    ["language"] = "Spanish",
    ["text"] = "Hello"
});
```

### Plugins

Extend Semantic Kernel with custom functionality:

```csharp
[KernelFunction("FunctionName")]
[Description("Function description for AI")]
public string MyFunction(
    [Description("Parameter description")] string param)
{
    // Implementation
}
```

### Auto-function Calling

AI decides when to call functions:

```csharp
var settings = new OpenAIPromptExecutionSettings
{
    FunctionChoiceBehavior = FunctionChoiceBehavior.Auto()
};

var response = await chatService.GetChatMessageContentAsync(
    history, settings, kernel);
```

## 🎓 Learning Path

1. **Start with Demo 1** - Understand basic chat completion
2. **Try Demo 2** - Learn about conversation history
3. **Experiment with Demo 3** - See streaming in action
4. **Move to Demo 4** - Master prompt templates
5. **Explore Demo 5** - Create custom plugins
6. **Finish with Demo 6** - Experience auto-function calling

## 💡 Customization Ideas

### Add More Plugins

```csharp
builder.Plugins.AddFromType<WeatherPlugin>();
builder.Plugins.AddFromType<OrderPlugin>();
builder.Plugins.AddFromType<CustomerPlugin>();
```

### Use Different Models

Modify the deployment name to use different Azure OpenAI models:
- `gpt-4o` - Latest GPT-4 Omni (recommended)
- `gpt-4-turbo` - GPT-4 Turbo
- `gpt-4` - Standard GPT-4
- `gpt-35-turbo` - GPT-3.5 Turbo (faster, cheaper)

### Add Persistent Storage

Integrate with databases for product data:
```csharp
builder.Plugins.AddFromObject(new ProductPlugin(dbContext));
```

### Implement RAG (Retrieval Augmented Generation)

Add vector search and embeddings:
```csharp
builder.AddAzureOpenAITextEmbeddingGeneration(...);
// Use embeddings for semantic search
```

## 🔒 Security Best Practices

1. **Never commit secrets** - Always use User Secrets or environment variables
2. **Rotate API keys** - Regularly rotate your Azure OpenAI keys
3. **Use managed identities** - In production, use Azure Managed Identities instead of API keys
4. **Monitor usage** - Track API usage to prevent unexpected costs
5. **Implement rate limiting** - Add throttling for production applications

## 🐛 Troubleshooting

### "Missing Azure OpenAI configuration"

**Problem**: Application can't find your credentials

**Solutions**:
1. Verify user secrets are set: `dotnet user-secrets list`
2. Check environment variables: `echo $AzureOpenAI__Endpoint`
3. Ensure correct syntax (colons in user secrets, underscores in env vars)

### "401 Unauthorized" or "Access Denied"

**Problem**: Invalid API key or endpoint

**Solutions**:
1. Verify API key in Azure Portal (Keys and Endpoint section)
2. Check endpoint URL format: `https://<resource>.openai.azure.com/`
3. Ensure API key has proper permissions

### "404 Not Found" or "DeploymentNotFound"

**Problem**: Deployment name doesn't exist

**Solutions**:
1. Verify deployment name in Azure Portal (Model deployments)
2. Check for typos in deployment name
3. Ensure model is fully deployed (not in progress)

### Build Errors

**Problem**: Package restore or build failures

**Solutions**:
```bash
# Clean and rebuild
dotnet clean
dotnet restore
dotnet build

# Clear NuGet cache
dotnet nuget locals all --clear
```

## 📖 Additional Resources

### Official Documentation
- [Semantic Kernel Documentation](https://learn.microsoft.com/semantic-kernel/)
- [Azure OpenAI Service](https://learn.microsoft.com/azure/ai-services/openai/)
- [.NET 9 Documentation](https://learn.microsoft.com/dotnet/core/whats-new/dotnet-9)

### Tutorials and Samples
- [Semantic Kernel GitHub Repo](https://github.com/microsoft/semantic-kernel)
- [Semantic Kernel Samples](https://github.com/microsoft/semantic-kernel/tree/main/dotnet/samples)
- [Learn Semantic Kernel](https://learn.microsoft.com/semantic-kernel/get-started/)

### Community
- [Semantic Kernel Discord](https://aka.ms/SKDiscord)
- [Stack Overflow - semantic-kernel tag](https://stackoverflow.com/questions/tagged/semantic-kernel)

## 📄 License

This demo is part of the BESTSELLER AI Hackathon 2025 repository.
See the main repository LICENSE file for licensing information.

## 🤝 Contributing

This is a demo/sample project. Feel free to:
- Use it as a starting point for your own projects
- Modify and extend the functionality
- Share improvements and learnings

## 💬 Feedback

Questions or issues? Please refer to:
- Main repository README: `../../../README.md`
- Best practices guide: `../../../agents.md`
- Azure OpenAI documentation

---

**Happy coding with Semantic Kernel!** 🚀
