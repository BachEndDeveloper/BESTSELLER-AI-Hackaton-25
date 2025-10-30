using Microsoft.Extensions.Configuration;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.ChatCompletion;
using Microsoft.SemanticKernel.Connectors.OpenAI;

namespace SemanticKernelDemo;

/// <summary>
/// Demonstrates Microsoft Semantic Kernel integration with Azure OpenAI.
/// This demo showcases:
/// - Basic chat completion
/// - Conversation history
/// - Streaming responses
/// - Semantic functions (prompts)
/// - Plugin usage
/// </summary>
class Program
{
    static async Task Main(string[] args)
    {
        Console.WriteLine("╔══════════════════════════════════════════════════════════════╗");
        Console.WriteLine("║  Semantic Kernel Demo - Azure OpenAI Integration            ║");
        Console.WriteLine("║  .NET 9 + Semantic Kernel 1.66.0                            ║");
        Console.WriteLine("╚══════════════════════════════════════════════════════════════╝");
        Console.WriteLine();

        // Load configuration from user secrets and environment variables
        var config = new ConfigurationBuilder()
            .AddUserSecrets<Program>()
            .AddEnvironmentVariables()
            .Build();

        var endpoint = config["AzureOpenAI:Endpoint"];
        var apiKey = config["AzureOpenAI:ApiKey"];
        var deploymentName = config["AzureOpenAI:DeploymentName"];

        if (string.IsNullOrEmpty(endpoint) || string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(deploymentName))
        {
            Console.WriteLine("❌ Missing Azure OpenAI configuration!");
            Console.WriteLine();
            Console.WriteLine("Please configure the following:");
            Console.WriteLine("  • AzureOpenAI:Endpoint");
            Console.WriteLine("  • AzureOpenAI:ApiKey");
            Console.WriteLine("  • AzureOpenAI:DeploymentName");
            Console.WriteLine();
            Console.WriteLine("Using User Secrets (recommended for development):");
            Console.WriteLine("  dotnet user-secrets set \"AzureOpenAI:Endpoint\" \"https://your-resource.openai.azure.com/\"");
            Console.WriteLine("  dotnet user-secrets set \"AzureOpenAI:ApiKey\" \"your-api-key\"");
            Console.WriteLine("  dotnet user-secrets set \"AzureOpenAI:DeploymentName\" \"gpt-4o\"");
            Console.WriteLine();
            Console.WriteLine("Or using environment variables:");
            Console.WriteLine("  export AzureOpenAI__Endpoint=\"https://your-resource.openai.azure.com/\"");
            Console.WriteLine("  export AzureOpenAI__ApiKey=\"your-api-key\"");
            Console.WriteLine("  export AzureOpenAI__DeploymentName=\"gpt-4o\"");
            return;
        }

        Console.WriteLine("✓ Azure OpenAI configuration loaded");
        Console.WriteLine($"  Endpoint: {endpoint}");
        Console.WriteLine($"  Deployment: {deploymentName}");
        Console.WriteLine();

        // Create the Semantic Kernel
        var builder = Kernel.CreateBuilder();
        builder.AddAzureOpenAIChatCompletion(
            deploymentName: deploymentName,
            endpoint: endpoint,
            apiKey: apiKey);

        // Add a custom plugin
        builder.Plugins.AddFromType<ProductPlugin>();

        var kernel = builder.Build();

        Console.WriteLine("✓ Semantic Kernel initialized");
        Console.WriteLine();

        // Demo menu
        while (true)
        {
            Console.WriteLine("───────────────────────────────────────────────────────────────");
            Console.WriteLine("Select a demo:");
            Console.WriteLine("  1. Simple Chat Completion");
            Console.WriteLine("  2. Conversation with History");
            Console.WriteLine("  3. Streaming Response");
            Console.WriteLine("  4. Semantic Function (Prompt Template)");
            Console.WriteLine("  5. Plugin Usage (Product Catalog)");
            Console.WriteLine("  6. Advanced: Chat with Auto-function Calling");
            Console.WriteLine("  0. Exit");
            Console.WriteLine("───────────────────────────────────────────────────────────────");
            Console.Write("Enter your choice: ");

            var choice = Console.ReadLine();
            Console.WriteLine();

            switch (choice)
            {
                case "1":
                    await SimpleChatCompletionDemo(kernel);
                    break;
                case "2":
                    await ConversationWithHistoryDemo(kernel);
                    break;
                case "3":
                    await StreamingResponseDemo(kernel);
                    break;
                case "4":
                    await SemanticFunctionDemo(kernel);
                    break;
                case "5":
                    await PluginUsageDemo(kernel);
                    break;
                case "6":
                    await AutoFunctionCallingDemo(kernel);
                    break;
                case "0":
                    Console.WriteLine("👋 Goodbye!");
                    return;
                default:
                    Console.WriteLine("❌ Invalid choice. Please try again.");
                    Console.WriteLine();
                    break;
            }
        }
    }

    /// <summary>
    /// Demo 1: Simple chat completion with a single message
    /// </summary>
    static async Task SimpleChatCompletionDemo(Kernel kernel)
    {
        Console.WriteLine("═══ Demo 1: Simple Chat Completion ═══");
        Console.Write("Enter your message: ");
        var userMessage = Console.ReadLine();

        if (string.IsNullOrWhiteSpace(userMessage))
        {
            Console.WriteLine("❌ Message cannot be empty.");
            Console.WriteLine();
            return;
        }

        var chatService = kernel.GetRequiredService<IChatCompletionService>();
        var response = await chatService.GetChatMessageContentAsync(userMessage);

        Console.WriteLine();
        Console.WriteLine($"🤖 Assistant: {response.Content}");
        Console.WriteLine();
    }

    /// <summary>
    /// Demo 2: Conversation with history - maintains context across multiple turns
    /// </summary>
    static async Task ConversationWithHistoryDemo(Kernel kernel)
    {
        Console.WriteLine("═══ Demo 2: Conversation with History ═══");
        Console.WriteLine("Type 'exit' to end the conversation");
        Console.WriteLine();

        var chatService = kernel.GetRequiredService<IChatCompletionService>();
        var history = new ChatHistory();

        // Add a system message to set the assistant's behavior
        history.AddSystemMessage("You are a helpful AI assistant specialized in fashion and retail.");

        while (true)
        {
            Console.Write("👤 You: ");
            var userMessage = Console.ReadLine();

            if (string.IsNullOrWhiteSpace(userMessage) || userMessage.Equals("exit", StringComparison.OrdinalIgnoreCase))
            {
                Console.WriteLine("Ending conversation.");
                Console.WriteLine();
                break;
            }

            history.AddUserMessage(userMessage);

            var response = await chatService.GetChatMessageContentAsync(history);
            history.AddAssistantMessage(response.Content!);

            Console.WriteLine($"🤖 Assistant: {response.Content}");
            Console.WriteLine();
        }
    }

    /// <summary>
    /// Demo 3: Streaming response - shows tokens as they arrive
    /// </summary>
    static async Task StreamingResponseDemo(Kernel kernel)
    {
        Console.WriteLine("═══ Demo 3: Streaming Response ═══");
        Console.Write("Enter your message: ");
        var userMessage = Console.ReadLine();

        if (string.IsNullOrWhiteSpace(userMessage))
        {
            Console.WriteLine("❌ Message cannot be empty.");
            Console.WriteLine();
            return;
        }

        var chatService = kernel.GetRequiredService<IChatCompletionService>();
        Console.WriteLine();
        Console.Write("🤖 Assistant: ");

        await foreach (var chunk in chatService.GetStreamingChatMessageContentsAsync(userMessage))
        {
            Console.Write(chunk.Content);
        }

        Console.WriteLine();
        Console.WriteLine();
    }

    /// <summary>
    /// Demo 4: Semantic function using prompt templates
    /// </summary>
    static async Task SemanticFunctionDemo(Kernel kernel)
    {
        Console.WriteLine("═══ Demo 4: Semantic Function (Prompt Template) ═══");
        Console.Write("Enter a product name: ");
        var productName = Console.ReadLine();

        if (string.IsNullOrWhiteSpace(productName))
        {
            Console.WriteLine("❌ Product name cannot be empty.");
            Console.WriteLine();
            return;
        }

        // Create a semantic function using a prompt template
        var prompt = @"
You are a creative marketing expert for BESTSELLER, a leading fashion company.
Generate an engaging product description for the following item:

Product: {{$productName}}

Requirements:
- Make it appealing and professional
- Highlight potential features and benefits
- Keep it concise (2-3 sentences)
- Use a friendly, modern tone

Product Description:";

        var function = kernel.CreateFunctionFromPrompt(prompt);

        var arguments = new KernelArguments
        {
            ["productName"] = productName
        };

        Console.WriteLine();
        Console.WriteLine("Generating product description...");
        var result = await kernel.InvokeAsync(function, arguments);

        Console.WriteLine();
        Console.WriteLine("📝 Generated Description:");
        Console.WriteLine(result.ToString());
        Console.WriteLine();
    }

    /// <summary>
    /// Demo 5: Using plugins to extend functionality
    /// </summary>
    static async Task PluginUsageDemo(Kernel kernel)
    {
        Console.WriteLine("═══ Demo 5: Plugin Usage (Product Catalog) ═══");
        Console.WriteLine();

        // Directly call plugin functions
        var getProductsFunction = kernel.Plugins.GetFunction("ProductPlugin", "GetProducts");
        var productsResult = await kernel.InvokeAsync(getProductsFunction);

        Console.WriteLine("📦 Available Products:");
        Console.WriteLine(productsResult.ToString());
        Console.WriteLine();

        Console.Write("Enter a product ID to check stock: ");
        var productId = Console.ReadLine();

        if (!string.IsNullOrWhiteSpace(productId))
        {
            var checkStockFunction = kernel.Plugins.GetFunction("ProductPlugin", "CheckStock");
            var arguments = new KernelArguments
            {
                ["productId"] = productId
            };

            var stockResult = await kernel.InvokeAsync(checkStockFunction, arguments);
            Console.WriteLine();
            Console.WriteLine($"📊 Stock Status: {stockResult}");
        }

        Console.WriteLine();
    }

    /// <summary>
    /// Demo 6: Auto-function calling - AI automatically decides when to call plugin functions
    /// </summary>
    static async Task AutoFunctionCallingDemo(Kernel kernel)
    {
        Console.WriteLine("═══ Demo 6: Auto-function Calling ═══");
        Console.WriteLine("The AI can automatically use the ProductPlugin when needed.");
        Console.WriteLine("Try asking questions like:");
        Console.WriteLine("  - 'What products are available?'");
        Console.WriteLine("  - 'Is item-001 in stock?'");
        Console.WriteLine("  - 'Tell me about the stock status of item-002'");
        Console.WriteLine();
        Console.Write("Enter your question: ");
        var userMessage = Console.ReadLine();

        if (string.IsNullOrWhiteSpace(userMessage))
        {
            Console.WriteLine("❌ Message cannot be empty.");
            Console.WriteLine();
            return;
        }

        var chatService = kernel.GetRequiredService<IChatCompletionService>();

        // Enable auto-function calling
        var executionSettings = new OpenAIPromptExecutionSettings
        {
            FunctionChoiceBehavior = FunctionChoiceBehavior.Auto()
        };

        var history = new ChatHistory();
        history.AddSystemMessage("You are a helpful assistant for BESTSELLER product catalog. Use the available functions to help answer questions about products and stock.");
        history.AddUserMessage(userMessage);

        Console.WriteLine();
        Console.WriteLine("🤖 Assistant: ");

        var response = await chatService.GetChatMessageContentAsync(history, executionSettings, kernel);

        Console.WriteLine(response.Content);
        Console.WriteLine();
    }
}

/// <summary>
/// Custom plugin that provides product catalog functionality
/// </summary>
public class ProductPlugin
{
    private static readonly Dictionary<string, Product> _products = new()
    {
        ["item-001"] = new Product("item-001", "Classic T-Shirt", 29.99m, 150),
        ["item-002"] = new Product("item-002", "Slim Fit Jeans", 79.99m, 75),
        ["item-003"] = new Product("item-003", "Cotton Hoodie", 59.99m, 0),
        ["item-004"] = new Product("item-004", "Running Shoes", 129.99m, 45),
        ["item-005"] = new Product("item-005", "Leather Jacket", 299.99m, 12)
    };

    /// <summary>
    /// Gets all available products in the catalog
    /// </summary>
    [KernelFunction("GetProducts")]
    [System.ComponentModel.Description("Gets a list of all available products in the catalog")]
    public string GetProducts()
    {
        var productList = _products.Values
            .Select(p => $"- {p.ItemId}: {p.Name} (${p.Price}) - Stock: {p.StockQuantity}")
            .ToList();

        return string.Join("\n", productList);
    }

    /// <summary>
    /// Checks stock availability for a specific product
    /// </summary>
    [KernelFunction("CheckStock")]
    [System.ComponentModel.Description("Checks the stock availability for a specific product by ID")]
    public string CheckStock(
        [System.ComponentModel.Description("The product ID to check stock for")]
        string productId)
    {
        if (_products.TryGetValue(productId, out var product))
        {
            if (product.StockQuantity > 0)
            {
                return $"{product.Name} is IN STOCK with {product.StockQuantity} units available at ${product.Price}";
            }
            else
            {
                return $"{product.Name} is OUT OF STOCK (Price: ${product.Price})";
            }
        }

        return $"Product '{productId}' not found in catalog";
    }

    /// <summary>
    /// Gets detailed information about a specific product
    /// </summary>
    [KernelFunction("GetProductDetails")]
    [System.ComponentModel.Description("Gets detailed information about a specific product")]
    public string GetProductDetails(
        [System.ComponentModel.Description("The product ID to get details for")]
        string productId)
    {
        if (_products.TryGetValue(productId, out var product))
        {
            return $"Product: {product.Name}\nID: {product.ItemId}\nPrice: ${product.Price}\nStock: {product.StockQuantity} units";
        }

        return $"Product '{productId}' not found";
    }

    private record Product(string ItemId, string Name, decimal Price, int StockQuantity);
}
