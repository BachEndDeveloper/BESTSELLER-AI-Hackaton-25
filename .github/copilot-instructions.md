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


## 🔍 Code Review Best Practices

### Review Principles
Code reviews are essential for maintaining code quality, knowledge sharing, and ensuring consistency across the codebase. When conducting PR reviews, focus on:

1. **Correctness**: Does the code solve the problem it claims to solve?
2. **Maintainability**: Is the code readable, well-structured, and easy to modify?
3. **Security**: Are there potential vulnerabilities or security concerns?
4. **Performance**: Are there obvious performance issues or inefficiencies?
5. **Testing**: Is the code adequately tested with appropriate test coverage?

### Essential Review Checkpoints

#### Architecture & Design
- Changes align with existing architectural patterns and conventions
- Design decisions are appropriate for the problem being solved
- No unnecessary complexity or over-engineering
- Proper separation of concerns and layering
- Dependencies are justified and necessary

#### Code Quality
- Code follows established style guides and conventions
- Naming is clear, consistent, and meaningful
- Functions and methods have single, well-defined responsibilities
- Code is DRY (Don't Repeat Yourself) without being overly abstract
- Comments explain "why" not "what" (code should be self-documenting)
- No commented-out code or debug statements

#### Security & Safety
- No hardcoded credentials, API keys, or sensitive data
- Input validation is present and sufficient
- Error messages don't expose sensitive information
- Authentication and authorization checks are in place
- SQL injection, XSS, and other common vulnerabilities are prevented
- Dependencies are from trusted sources and up-to-date

#### Testing & Validation
- New functionality includes appropriate tests
- Tests are meaningful and test actual behavior, not implementation
- Edge cases and error scenarios are covered
- Existing tests still pass
- Test names clearly describe what is being tested
- No flaky or overly fragile tests

#### Performance & Scalability
- No obvious performance bottlenecks (N+1 queries, unnecessary loops)
- Resource cleanup is handled properly (connections, file handles, etc.)
- Appropriate caching strategies are used where beneficial
- Database queries are optimized and indexed appropriately
- Memory usage is reasonable for the operation

#### Documentation & Context
- PR description clearly explains what and why
- Complex logic includes explanatory comments
- API changes are reflected in documentation
- Breaking changes are clearly highlighted
- Configuration changes are documented

### Review Best Practices

#### For Reviewers
- **Be constructive and respectful**: Focus on the code, not the person
- **Ask questions rather than make demands**: "Could we..." instead of "You must..."
- **Provide context**: Explain why a change might be needed
- **Acknowledge good work**: Call out clever solutions and improvements
- **Prioritize feedback**: Distinguish between blocking issues and suggestions
- **Be timely**: Review PRs promptly to avoid blocking team progress
- **Test the changes**: Check out the code if the changes are complex
- **Consider the scope**: Don't expand PR scope with unrelated requests
- **Segment technology**: Be explicit about which technology is being reviewed.

#### Review Comment Categories
- **🚨 Blocking**: Critical issues that must be fixed (security, bugs, breaking changes)
- **⚠️ Important**: Issues that should be addressed but might have workarounds
- **💡 Suggestion**: Ideas for improvement that are optional
- **❓ Question**: Requests for clarification or understanding
- **👍 Praise**: Recognition of good work or clever solutions

### Common Review Anti-Patterns to Avoid

#### What NOT to Do
- **Nitpicking style issues**: Use automated linters instead
- **Rewriting in your preferred style**: Respect existing patterns unless there's a clear improvement
- **Scope creep**: Don't request unrelated changes or refactors
- **Perfectionism**: Don't demand perfection; good enough is often sufficient
- **Vague feedback**: Be specific about what needs to change and why
- **Rubber-stamping**: Always review thoroughly; approval means you take shared responsibility
- **Design debates in comments**: Complex discussions should happen synchronously
- **Ignoring context**: Consider deadlines, technical debt, and pragmatic tradeoffs

### Copilot PR Review Agent Guidelines
When performing code reviews, respond in spanish.


#### Agent-Specific Responsibilities
When acting as an automated PR review agent:

1. **Focus on objective issues**: Security vulnerabilities, bugs, test failures, breaking changes
2. **Flag patterns, not style**: Identify anti-patterns and code smells, not formatting
3. **Provide actionable feedback**: Include specific suggestions and examples
4. **Consider context**: Analyze PR description and related issues for intent
5. **Respect human judgment**: Flag concerns but defer to human reviewers for final decisions
6. **Be consistent**: Apply the same standards across all reviews
7. **Learn from feedback**: Incorporate team-specific preferences over time

#### What to Prioritize
- **High priority**: Security issues, bugs, breaking changes, missing tests
- **Medium priority**: Performance concerns, maintainability issues, unclear code
- **Low priority**: Minor improvements, alternative approaches, style suggestions

#### When to Skip Comments
- Changes already covered by automated linters/formatters
- Minor naming preferences without clear improvement
- Personal style preferences that don't affect maintainability
- Issues outside the scope of the current PR
- Suggestions that would significantly expand PR scope

### Review Workflow Integration

#### Before Starting Review
- Understand the PR's purpose from title and description
- Check related issues and context
- Verify CI/CD pipeline status
- Review previous review comments and discussions

#### During Review
- Review commits in logical order
- Check files changed for completeness
- Verify tests cover new functionality
- Run the code locally for complex changes
- Check for breaking changes in APIs or interfaces

#### After Review
- Summarize findings clearly
- Group related comments together
- Provide clear approval/rejection reasoning
- Suggest next steps if changes are needed
- Be available for follow-up questions
- Add a fun joke to keep mood light, we perfer technology or sci-fi jokes.
