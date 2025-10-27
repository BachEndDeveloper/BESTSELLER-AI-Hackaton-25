# BESTSELLER AI Hackathon 2025 - Copilot Instructions

## 🎯 Project Overview

This is a hackathon repository providing starter templates and reference implementations for integrating AI capabilities into backend services using **Microsoft Semantic Kernel**. The project supports three technology stacks: Java/Spring, .NET/Aspire, and Python/FastAPI.

## 📁 Critical Repository Structure

```
├── demo/           # Starter templates (minimal, educational)
├── sample/         # Complete reference implementations  
├── scripts/        # PostgreSQL database setup scripts
├── agents.md       # Comprehensive AI development guidelines
├── openapi.yaml    # BESTSELLER API specification
└── .github/instructions/  # Language-specific coding guidelines
```

**Key Pattern**: Each language has dedicated directories under both `demo/` and `sample/` with identical structure: `{demo|sample}/{java|dotnet|python}/`

## 🔧 Technology Stack Requirements

### Mandatory AI Integration
- **Microsoft Semantic Kernel** is the ONLY approved LLM library
- All AI features must use Semantic Kernel patterns and APIs
- Never substitute with OpenAI SDK, LangChain, or other libraries

### Language-Specific Frameworks
- **Java**: Spring Boot 3.x with WebFlux (reactive patterns)
- **.NET**: .NET 9 with Aspire (cloud-ready distributed apps)  
- **Python**: FastAPI with async/await patterns

## 🗃️ Database & API Architecture

### PostgreSQL Schema (see `scripts/`)
- **items** table: Product catalog (ItemSummary/ItemDetail models)
- **stock** table: Inventory management (StockInfo model)
- **tracking** tables: Shipment tracking (TrackingInfo/TrackingEvent models)

### API Contract (`openapi.yaml`)
- REST endpoints: `/items`, `/stock/{itemId}`, `/track/{trackingNo}`
- Standardized response schemas with proper error handling
- Multiple server environments (prod/staging/local)

## 💡 Development Patterns

### Project Differentiation
- **`demo/` projects**: Keep minimal, educational, single AI feature
- **`sample/` projects**: Comprehensive implementations showcasing best practices

### Code Organization
- Follow language-specific `.editorconfig` formatting rules
- Respect existing dependency injection patterns
- Use structured logging with proper error handling
- External configuration for API keys (never hardcode secrets)

### AI Integration Patterns
```java
// Java example
@Service 
public class AiService {
    private final Kernel kernel;
    // Semantic Kernel implementation
}
```

```csharp
// .NET example  
public class AiService {
    private readonly Kernel _kernel;
    // Semantic Kernel implementation
}
```

```python
# Python example
class AiService:
    def __init__(self, kernel: Kernel):
        self.kernel = kernel
    # Semantic Kernel implementation
```

## 🚀 Quick Start Commands

### Database Setup
```bash
# Run PostgreSQL scripts in order
for script in scripts/*.sql; do
    psql -U postgres -d ai-demo -f "$script"
done
```

### Language-Specific Setup
- **Java**: `mvn spring-boot:run` or `gradle bootRun`
- **.NET**: `dotnet run` (ensure Aspire workload installed)
- **Python**: `pip install -r requirements.txt && uvicorn main:app`

## 📋 Quality Standards

### Security First
- API keys via environment variables/secret stores only
- Input validation on all endpoints
- Proper error handling without sensitive data exposure

### Testing Requirements  
- Unit tests for AI integrations with mocked Semantic Kernel
- Integration tests for database interactions
- API endpoint smoke tests with example requests

### Documentation Standards
- Update language-specific READMEs when adding features
- Include setup instructions and example API calls
- Document AI prompt engineering decisions

## 🎛️ Configuration Patterns

### Required Environment Variables
- `OPENAI_API_KEY` or equivalent for Semantic Kernel
- Database connection strings  
- External service endpoints

### Framework-Specific Config
- **Java**: `application.yml` with Spring profiles
- **.NET**: `appsettings.json` with `IOptions<T>` pattern
- **Python**: Pydantic settings with `.env` support

## 🔍 Common Integration Points

### Cross-Language Consistency
- All implementations should support the same OpenAPI contract
- Database schema compatibility across all stacks
- Consistent error response formats (ProblemDetails pattern)
- Shared logging and observability patterns

### AI Feature Examples
- Item description enhancement using product catalog
- Stock level predictions based on historical data  
- Intelligent tracking status updates and notifications
- Customer query processing for item/order information

## ⚠️ Critical Guidelines

1. **Never break language isolation** - keep Java, .NET, and Python implementations completely separate
2. **Semantic Kernel only** - don't introduce competing AI libraries
3. **Respect demo vs sample distinction** - templates stay minimal, samples can be comprehensive  
4. **Follow existing patterns** - observe established DI, logging, and error handling conventions
5. **Database compatibility** - all implementations must work with the same PostgreSQL schema

## 📚 Reference Files

- **Detailed language patterns**: `.github/instructions/{java|dotnet|python}.instructions.md`
- **AI development best practices**: `agents.md` (comprehensive guidelines)
- **API contracts**: `openapi.yaml` and `OPENAPI-README.md`
- **Database schema**: `scripts/README.md` and SQL files