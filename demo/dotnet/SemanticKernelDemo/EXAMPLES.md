# Semantic Kernel Demo - Application Output Examples

## Application Startup

When you run the application, you'll see:

```
╔══════════════════════════════════════════════════════════════╗
║  Semantic Kernel Demo - Azure OpenAI Integration            ║
║  .NET 9 + Semantic Kernel 1.66.0                            ║
╚══════════════════════════════════════════════════════════════╝

✓ Azure OpenAI configuration loaded
  Endpoint: https://your-resource.openai.azure.com/
  Deployment: gpt-4o

✓ Semantic Kernel initialized
```

## Main Menu

```
───────────────────────────────────────────────────────────────
Select a demo:
  1. Simple Chat Completion
  2. Conversation with History
  3. Streaming Response
  4. Semantic Function (Prompt Template)
  5. Plugin Usage (Product Catalog)
  6. Advanced: Chat with Auto-function Calling
  0. Exit
───────────────────────────────────────────────────────────────
Enter your choice:
```

## Demo Outputs

### Demo 1: Simple Chat Completion

```
═══ Demo 1: Simple Chat Completion ═══
Enter your message: What is Semantic Kernel?

🤖 Assistant: Semantic Kernel is an open-source SDK from Microsoft that helps 
developers integrate AI capabilities into their applications...
```

### Demo 2: Conversation with History

```
═══ Demo 2: Conversation with History ═══
Type 'exit' to end the conversation

👤 You: I'm looking for a t-shirt
🤖 Assistant: I'd be happy to help you find a t-shirt! We have a variety of 
styles available...

👤 You: What colors do you have?
🤖 Assistant: Based on our previous discussion about t-shirts, we have several 
colors available including...
```

### Demo 3: Streaming Response

```
═══ Demo 3: Streaming Response ═══
Enter your message: Tell me about fashion trends

🤖 Assistant: Fashion trends in 2025 are focusing on sustainability...
[Words appear one by one as they're generated]
```

### Demo 4: Semantic Function (Prompt Template)

```
═══ Demo 4: Semantic Function (Prompt Template) ═══
Enter a product name: Classic T-Shirt

Generating product description...

📝 Generated Description:
Discover timeless style with our Classic T-Shirt, crafted from premium cotton 
for all-day comfort. This versatile wardrobe essential features a modern fit 
and exceptional quality that stands the test of time.
```

### Demo 5: Plugin Usage (Product Catalog)

```
═══ Demo 5: Plugin Usage (Product Catalog) ═══

📦 Available Products:
- item-001: Classic T-Shirt ($29.99) - Stock: 150
- item-002: Slim Fit Jeans ($79.99) - Stock: 75
- item-003: Cotton Hoodie ($59.99) - Stock: 0
- item-004: Running Shoes ($129.99) - Stock: 45
- item-005: Leather Jacket ($299.99) - Stock: 12

Enter a product ID to check stock: item-001

📊 Stock Status: Classic T-Shirt is IN STOCK with 150 units available at $29.99
```

### Demo 6: Auto-function Calling

```
═══ Demo 6: Auto-function Calling ═══
The AI can automatically use the ProductPlugin when needed.
Try asking questions like:
  - 'What products are available?'
  - 'Is item-001 in stock?'
  - 'Tell me about the stock status of item-002'

Enter your question: Is item-001 in stock?

🤖 Assistant: 
Yes! The Classic T-Shirt (item-001) is IN STOCK with 150 units available at $29.99
```

## Configuration Error Message

If Azure OpenAI is not configured, you'll see helpful instructions:

```
❌ Missing Azure OpenAI configuration!

Please configure the following:
  • AzureOpenAI:Endpoint
  • AzureOpenAI:ApiKey
  • AzureOpenAI:DeploymentName

Using User Secrets (recommended for development):
  dotnet user-secrets set "AzureOpenAI:Endpoint" "https://your-resource.openai.azure.com/"
  dotnet user-secrets set "AzureOpenAI:ApiKey" "your-api-key"
  dotnet user-secrets set "AzureOpenAI:DeploymentName" "gpt-4o"

Or using environment variables:
  export AzureOpenAI__Endpoint="https://your-resource.openai.azure.com/"
  export AzureOpenAI__ApiKey="your-api-key"
  export AzureOpenAI__DeploymentName="gpt-4o"
```

## Exit

```
───────────────────────────────────────────────────────────────
Enter your choice: 0

👋 Goodbye!
```

---

## Interactive Features

- **Clear visual hierarchy** with box characters and emojis
- **Helpful prompts** at every step
- **Real-time feedback** for streaming responses
- **Error messages** with actionable solutions
- **Professional formatting** with separators and sections

## Key UI Elements

- ✓ Success indicators (checkmarks)
- 🤖 AI responses (robot emoji)
- 👤 User messages (person emoji)
- 📦 Product lists (package emoji)
- 📊 Stock information (chart emoji)
- 📝 Generated content (memo emoji)
- ❌ Error messages (cross mark)
- 👋 Exit message (wave emoji)

---

**The interface is designed to be intuitive, informative, and engaging!**
