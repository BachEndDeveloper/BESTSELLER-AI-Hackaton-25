# AI Agents Guidelines and Best Practices

This document provides comprehensive guidelines for AI agents working on the BESTSELLER AI Hackathon repository, as well as best practices for each programming language and technology stack.

## 🤖 Agent Guidelines

### Repository Structure Adherence

When working with this repository, agents MUST:

1. **Respect the directory structure**:
   - `sample/` contains starter templates - keep them minimal and focused
   - `demo/` contains complete implementations - these can be more comprehensive
   - Each language has its own subdirectory: `java/`, `dotnet/`, `python/`

2. **Use appropriate language directories**:
   - Java code → `*/java/` directories
   - .NET code → `*/dotnet/` directories  
   - Python code → `*/python/` directories

3. **Follow the .editorconfig standards**:
   - Each language directory has specific formatting rules
   - Respect indentation, line endings, and character limits
   - Use the provided style guidelines

### Code Generation Guidelines

#### When adding new files:
- Place them in the correct language-specific directory
- Follow the naming conventions for that language
- Include appropriate imports and package declarations
- Add necessary configuration files (e.g., `pom.xml`, `*.csproj`, `requirements.txt`)

#### When modifying existing code:
- Preserve the existing code style and patterns
- Maintain compatibility with the chosen framework
- Update documentation and comments when necessary
- Ensure changes align with the technology stack requirements

### AI Integration Requirements

All AI implementations MUST use **Microsoft Semantic Kernel**:
- Import the appropriate Semantic Kernel packages for your language
- Use Semantic Kernel patterns for LLM orchestration
- Implement proper error handling for AI operations
- Follow security best practices for API key management

## ☕ Java Best Practices

### Framework and Architecture
- **Spring Boot 3.x** is the required framework
- Use **Spring WebFlux** for reactive programming when appropriate
- Implement **dependency injection** using Spring's `@Autowired` or constructor injection
- Follow **layered architecture**: Controller → Service → Repository

### Code Style and Standards
- **Indentation**: 4 spaces (no tabs)
- **Line length**: Maximum 120 characters
- **Naming conventions**:
  - Classes: `PascalCase` (e.g., `UserService`)
  - Methods/variables: `camelCase` (e.g., `getUserById`)
  - Constants: `UPPER_SNAKE_CASE` (e.g., `MAX_RETRY_COUNT`)
  - Packages: lowercase with dots (e.g., `com.bestseller.ai`)

### Project Structure
```
src/
├── main/
│   ├── java/
│   │   └── com/bestseller/ai/
│   │       ├── controller/
│   │       ├── service/
│   │       ├── model/
│   │       ├── config/
│   │       └── Application.java
│   └── resources/
│       ├── application.yml
│       └── static/
└── test/
    └── java/
```

### Dependencies and Configuration
- Use **Maven** with `pom.xml` or **Gradle** with `build.gradle`
- Semantic Kernel Java: Include appropriate Microsoft Semantic Kernel dependencies
- Configuration via `application.yml` or `application.properties`
- Environment-specific profiles (dev, test, prod)

### AI Integration Patterns
```java
@Service
public class AiService {
    
    private final Kernel kernel;
    
    @Autowired
    public AiService(KernelBuilder kernelBuilder) {
        this.kernel = kernelBuilder.build();
    }
    
    public CompletableFuture<String> processPrompt(String input) {
        // Semantic Kernel implementation
    }
}
```

## 🔷 .NET Best Practices

### Framework and Architecture
- **.NET 9** with **ASP.NET Core**
- **Microsoft Aspire** for cloud-ready distributed applications
- Use **minimal APIs** or **controllers** based on complexity
- Implement **dependency injection** using built-in DI container

### Code Style and Standards
- **Indentation**: 4 spaces
- **Line length**: Maximum 120 characters
- **Naming conventions**:
  - Classes/Methods: `PascalCase` (e.g., `UserService`, `GetUserById`)
  - Private fields: `_camelCase` (e.g., `_userRepository`)
  - Local variables: `camelCase` (e.g., `userId`)
  - Constants: `PascalCase` (e.g., `MaxRetryCount`)

### Project Structure
```
├── Program.cs
├── appsettings.json
├── Controllers/
├── Services/
├── Models/
├── Configuration/
└── Properties/
```

### Dependencies and Configuration
- Use **NuGet packages** with `.csproj` files
- Semantic Kernel .NET: `Microsoft.SemanticKernel` package
- Configuration via `appsettings.json` and environment variables
- Use `IConfiguration` for accessing settings

### AI Integration Patterns
```csharp
public class AiService
{
    private readonly Kernel _kernel;
    
    public AiService(Kernel kernel)
    {
        _kernel = kernel;
    }
    
    public async Task<string> ProcessPromptAsync(string input)
    {
        // Semantic Kernel implementation
    }
}
```

## 🐍 Python Best Practices

### Framework and Architecture
- **Python 3.11+** with **FastAPI**
- Use **async/await** for asynchronous operations
- Implement **dependency injection** using FastAPI's dependency system
- Follow **layered architecture**: Router → Service → Repository

### Code Style and Standards
- **Indentation**: 4 spaces (no tabs)
- **Line length**: Maximum 88 characters (Black formatter standard)
- **Naming conventions**:
  - Classes: `PascalCase` (e.g., `UserService`)
  - Functions/variables: `snake_case` (e.g., `get_user_by_id`)
  - Constants: `UPPER_SNAKE_CASE` (e.g., `MAX_RETRY_COUNT`)
  - Private attributes: `_snake_case` (e.g., `_user_repository`)

### Project Structure
```
├── main.py
├── requirements.txt
├── pyproject.toml
├── app/
│   ├── __init__.py
│   ├── routers/
│   ├── services/
│   ├── models/
│   ├── config/
│   └── dependencies/
└── tests/
```

### Dependencies and Configuration
- Use **pip** with `requirements.txt` or **Poetry** with `pyproject.toml`
- Semantic Kernel Python: `semantic-kernel` package
- Use **Pydantic** for data validation and settings
- Environment variables via `.env` files

### AI Integration Patterns
```python
from semantic_kernel import Kernel

class AiService:
    def __init__(self, kernel: Kernel):
        self.kernel = kernel
    
    async def process_prompt(self, input_text: str) -> str:
        # Semantic Kernel implementation
        pass
```

## 🔧 General Development Guidelines

### Configuration Management
- **Never commit API keys or secrets** to version control
- Use environment variables for sensitive configuration
- Provide `.env.example` files with placeholder values
- Document all required environment variables

### Error Handling
- Implement comprehensive error handling for AI operations
- Use appropriate HTTP status codes
- Log errors with sufficient detail for debugging
- Provide meaningful error messages to users

### Testing Strategies
- Write unit tests for business logic
- Mock external AI services in tests
- Test error scenarios and edge cases
- Include integration tests for API endpoints

### Performance Considerations
- Implement rate limiting for AI operations
- Cache responses when appropriate
- Use connection pooling for database operations
- Monitor and log AI API usage and costs

### Security Best Practices
- Validate all input data
- Implement authentication and authorization
- Use HTTPS for all external communications
- Sanitize data before sending to AI services
- Implement proper CORS policies

### Documentation Standards
- Include README.md in each project with setup instructions
- Document API endpoints with OpenAPI/Swagger
- Comment complex business logic and AI integrations
- Provide examples of common use cases

## 🎯 Project-Specific Guidelines

### Sample Projects
- Keep implementations **minimal and educational**
- Focus on **one or two key AI features**
- Include **clear setup instructions**
- Provide **example requests and responses**

### Demo Projects  
- Showcase **comprehensive AI integration**
- Demonstrate **best practices in action**
- Include **multiple AI use cases**
- Provide **detailed documentation**

### Quality Assurance
- All code must follow the respective .editorconfig settings
- Include appropriate error handling and logging
- Ensure compatibility with the specified technology versions
- Test thoroughly before committing changes

## 📚 Resources and References

### Semantic Kernel Documentation
- [Microsoft Semantic Kernel Overview](https://learn.microsoft.com/en-us/semantic-kernel/)
- [Java SDK Documentation](https://learn.microsoft.com/en-us/semantic-kernel/java/)
- [.NET SDK Documentation](https://learn.microsoft.com/en-us/semantic-kernel/dotnet/)  
- [Python SDK Documentation](https://learn.microsoft.com/en-us/semantic-kernel/python/)

### Framework Documentation
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [.NET Aspire Documentation](https://learn.microsoft.com/en-us/dotnet/aspire/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)

Remember: The goal is to create high-quality, maintainable code that serves as an excellent foundation for hackathon participants to build upon!