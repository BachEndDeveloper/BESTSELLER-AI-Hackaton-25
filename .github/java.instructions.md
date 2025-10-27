---
applyTo: "**/java/*"
---

# GitHub Copilot Agent — Java/Spring Repository Instructions

**Audience:** GitHub Copilot (Agent mode), maintainers, contributors  
**Purpose:** Guide the Agent to generate secure, correct, maintainable Java/Spring code and collaborate effectively with humans.  
**Scope:** Java/Spring Boot services, libraries, and tooling in this repository.

---

## 0) Agent Behavior (must follow)

1. **Confirm scope & success criteria** in 3–7 bullets before coding (inputs/outputs, constraints, acceptance checks). Keep it brief; do **not** reveal internal chain-of-thought.
2. **Propose a plan**: files to add/modify, tests, and exact CLI commands to build/test/format.
3. **Change in small slices** (≤ ~150 LOC per file change). Prefer incremental PRs that compile and pass tests.
4. **Generate tests first or alongside code**; cover happy paths, key edge cases, errors/timeouts, and reactive streams behavior.
5. **Explain what & why (concise)**: assumptions, chosen patterns, trade‑offs. Link to official docs if suggesting unfamiliar APIs.
6. **Observe repo conventions** (formatting, analyzers, DI, logging, error shape). Align with existing patterns over introducing new ones.
7. **Security first**: no secrets or PII in code or logs; validate inputs; use platform security libraries; apply HTTP resiliency.
8. **No speculative dependencies**: justify any new package with benefit, security posture, and footprint.

**Do not:**

- Copy code from the web; generate original code.  
- Hard‑code secrets/URLs; use configuration and externalized properties.  
- Block on reactive types (`.block()`, `.toFuture().get()`), or create uncontrolled thread pools.  
- Introduce breaking changes silently.

---

## 1) Response Template (Agent output format)

**Use these headings in every significant response:**

- **Scope & Success Criteria**  
- **Plan** (files, patterns, tests)  
- **Changes** (summaries + rationale)  
- **Diffs / Code** (minimal, compilable)  
- **Tests** (what they verify)  
- **Run It** (exact CLI commands)  
- **Notes & Follow‑ups** (risks, next steps)

---

## 2) Repository Conventions (assumed defaults)

- **Java version:** Java 21 LTS or later (prefer latest LTS features like virtual threads, pattern matching, records)
- **Spring Boot:** 3.x (latest stable minor version)
- **Build tool:** Maven (default) or Gradle with Kotlin DSL
- **Layout:**
  ```
  src/
  ├── main/
  │   ├── java/
  │   └── resources/
  └── test/
      ├── java/
      └── resources/
  ```
- **Reactive:** Spring WebFlux with Project Reactor when dealing with async/streaming operations
- **Testing:** JUnit 5 + AssertJ or Spring Boot Test; use Testcontainers for integration tests
- **Formatting:** Follow `.editorconfig`; 4 spaces indentation, 120 char line length, LF line endings
- **Code quality:** Checkstyle, SpotBugs, PMD optional but recommended; enable compiler warnings
- **DI:** Spring Framework DI with constructor injection (prefer `final` fields)
- **Configuration:** `application.yml` + Spring profiles + externalized config; secrets via environment variables or Spring Cloud Config

> If the repository differs, detect and follow *existing* patterns.

---

## 3) AI‑Assisted Development Best Practices

- **Clarify**: Restate the problem and edge cases before proposing code.
- **Design sketch**: Show brief API contracts/DTOs/endpoints before large changes.
- **Offer options when impactful** (e.g., WebFlux vs. MVC, R2DBC vs. JDBC) and recommend one with trade‑offs.
- **Verify**: Include tests and commands. Provide a smoke test (curl/httpie) for endpoints.
- **License hygiene**: Original code only; short snippets mirroring official docs must be cited.
- **Team fit**: Reuse abstractions, logging patterns, error handling conventions, and folder structure.

---

## 4) Java Language Guidance (modern idioms)

- **Immutability by default**: prefer `record` types, `final` fields, unmodifiable collections (`List.of()`, `Set.of()`)
- **Null safety**: use `Optional<T>` for optional values; never return null from public APIs; use `@NonNull`/`@Nullable` annotations
- **Reactive programming**: use `Mono<T>` and `Flux<T>` from Project Reactor; avoid blocking operations in reactive chains
- **Async patterns**: prefer virtual threads (Java 21+) or reactive streams over traditional thread pools
- **Exception handling**: use specific exceptions; include context; avoid catching `Exception` or `Throwable`
- **Collections**: prefer immutable collections; use streams API for transformations; be mindful of stream terminal operations
- **Modern features**: 
  - Pattern matching for `instanceof` and `switch`
  - Records for DTOs and value objects
  - Sealed classes for domain modeling
  - Text blocks for multi-line strings
  - Virtual threads for high-concurrency scenarios

### Example: Modern Java Service
```java
@Service
public class ItemService {
    
    private final ItemRepository repository;
    private final Logger logger = LoggerFactory.getLogger(ItemService.class);
    
    public ItemService(ItemRepository repository) {
        this.repository = repository;
    }
    
    public Mono<ItemDetail> getItemById(String itemId) {
        Objects.requireNonNull(itemId, "itemId must not be null");
        logger.debug("Fetching item with id: {}", itemId);
        
        return repository.findById(itemId)
            .switchIfEmpty(Mono.error(() -> 
                new ItemNotFoundException("Item not found: " + itemId)))
            .doOnSuccess(item -> logger.info("Retrieved item: {}", item.id()))
            .doOnError(error -> logger.error("Error fetching item: {}", itemId, error));
    }
}
```

---

## 5) Spring Framework Guidance

### 5.1 Dependency Injection & Component Model

- **Constructor injection** (required dependencies, enables immutability):
```java
@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final NotificationService notificationService;
    
    public OrderService(OrderRepository orderRepository, 
                       NotificationService notificationService) {
        this.orderRepository = orderRepository;
        this.notificationService = notificationService;
    }
}
```

- **Component scanning**: use `@ComponentScan` judiciously; prefer explicit configuration for clarity
- **Bean scopes**: default Singleton for stateless; Prototype sparingly; RequestScope for web components
- **Conditional beans**: use `@ConditionalOnProperty`, `@ConditionalOnClass` for flexible configuration

### 5.2 Spring Boot Configuration

- **Externalized config** with `@ConfigurationProperties`:
```java
@ConfigurationProperties(prefix = "app.ai")
@Validated
public record AiConfiguration(
    @NotBlank String apiKey,
    @NotBlank String modelName,
    @Min(1) @Max(10) int maxRetries,
    Duration timeout
) {}
```

- Enable validation with `@Validated` and JSR-380 annotations
- Use Spring profiles for environment-specific config (`@Profile("dev")`)
- Secrets management: environment variables or Spring Cloud Config/Vault

### 5.3 Spring WebFlux & Reactive Programming

- **Router functions** for functional endpoints:
```java
@Configuration
public class ItemRouter {
    
    @Bean
    public RouterFunction<ServerResponse> itemRoutes(ItemHandler handler) {
        return RouterFunctions
            .route(GET("/api/items/{id}"), handler::getItem)
            .andRoute(GET("/api/items"), handler::listItems)
            .andRoute(POST("/api/items"), handler::createItem);
    }
}
```

- **Handler methods** return `Mono<ServerResponse>`:
```java
@Component
public class ItemHandler {
    
    private final ItemService itemService;
    
    public ItemHandler(ItemService itemService) {
        this.itemService = itemService;
    }
    
    public Mono<ServerResponse> getItem(ServerRequest request) {
        String itemId = request.pathVariable("id");
        return itemService.getItemById(itemId)
            .flatMap(item -> ServerResponse.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(item))
            .onErrorResume(ItemNotFoundException.class, e ->
                ServerResponse.notFound().build());
    }
}
```

- **Backpressure**: leverage Reactor's built-in backpressure; use `limitRate()` for control
- **Error handling**: use `.onErrorResume()`, `.onErrorReturn()`, `.doOnError()` appropriately
- **Avoid blocking**: never call `.block()` in reactive chains; use `@Async` or virtual threads for blocking operations

### 5.4 Data Access

#### R2DBC for Reactive Database Access
```java
public interface ItemRepository extends ReactiveCrudRepository<Item, String> {
    
    Flux<Item> findByCategory(String category);
    
    @Query("SELECT * FROM items WHERE price < :maxPrice")
    Flux<Item> findAffordableItems(@Param("maxPrice") BigDecimal maxPrice);
}
```

#### JPA/Hibernate for Traditional Access
- Use Spring Data JPA repositories
- Enable lazy loading carefully; avoid N+1 queries
- Use `@EntityGraph` or JOIN FETCH for eager loading
- Implement pagination with `Pageable`
- Use native queries sparingly; prefer JPQL

### 5.5 HTTP Client & Resiliency

- **WebClient** for reactive HTTP calls:
```java
@Configuration
public class WebClientConfig {
    
    @Bean
    public WebClient externalApiClient(WebClient.Builder builder,
                                       @Value("${external.api.url}") String baseUrl) {
        return builder
            .baseUrl(baseUrl)
            .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
            .codecs(configurer -> configurer.defaultCodecs()
                .maxInMemorySize(2 * 1024 * 1024))
            .build();
    }
}
```

- **Resilience patterns**: use Spring Cloud Circuit Breaker or Resilience4j:
```java
@Service
public class ResilientService {
    
    @CircuitBreaker(name = "externalApi", fallbackMethod = "fallbackMethod")
    @Retry(name = "externalApi")
    public Mono<ApiResponse> callExternalApi(String param) {
        return webClient.get()
            .uri("/endpoint?param={param}", param)
            .retrieve()
            .bodyToMono(ApiResponse.class);
    }
    
    private Mono<ApiResponse> fallbackMethod(String param, Exception ex) {
        logger.warn("Fallback triggered for param: {}", param, ex);
        return Mono.just(new ApiResponse("fallback data"));
    }
}
```

### 5.6 REST API Design

- **Controllers** for traditional MVC:
```java
@RestController
@RequestMapping("/api/items")
@Validated
public class ItemController {
    
    private final ItemService itemService;
    
    public ItemController(ItemService itemService) {
        this.itemService = itemService;
    }
    
    @GetMapping("/{id}")
    public Mono<ResponseEntity<ItemDetail>> getItem(
            @PathVariable @NotBlank String id) {
        return itemService.getItemById(id)
            .map(ResponseEntity::ok)
            .defaultIfEmpty(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public Mono<ResponseEntity<ItemDetail>> createItem(
            @Valid @RequestBody CreateItemRequest request) {
        return itemService.createItem(request)
            .map(item -> ResponseEntity
                .created(URI.create("/api/items/" + item.id()))
                .body(item));
    }
}
```

- **Validation**: use JSR-380 annotations (`@Valid`, `@NotNull`, `@Size`, etc.)
- **Error handling**: implement `@RestControllerAdvice` for global exception handling:
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ItemNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ItemNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(new ErrorResponse("NOT_FOUND", ex.getMessage()));
    }
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(
            MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .collect(Collectors.joining(", "));
        return ResponseEntity.badRequest()
            .body(new ErrorResponse("VALIDATION_ERROR", message));
    }
}
```

- **OpenAPI/Swagger**: use SpringDoc OpenAPI for documentation:
```java
@Configuration
public class OpenApiConfig {
    
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("BESTSELLER AI API")
                .version("1.0")
                .description("AI-powered product catalog API"));
    }
}
```

---

## 6) Semantic Kernel Integration (Microsoft AI)

**MANDATORY**: All AI features must use Microsoft Semantic Kernel for Java.

### 6.1 Kernel Setup & Configuration

```java
@Configuration
public class SemanticKernelConfig {
    
    @Bean
    public Kernel kernel(@Value("${openai.api.key}") String apiKey,
                        @Value("${openai.model}") String model) {
        
        var chatCompletion = OpenAIChatCompletion.builder()
            .withModelId(model)
            .withApiKey(apiKey)
            .build();
        
        return Kernel.builder()
            .withAIService(ChatCompletionService.class, chatCompletion)
            .build();
    }
}
```

### 6.2 AI Service Pattern

```java
@Service
public class AiEnhancementService {
    
    private final Kernel kernel;
    private final Logger logger = LoggerFactory.getLogger(AiEnhancementService.class);
    
    public AiEnhancementService(Kernel kernel) {
        this.kernel = kernel;
    }
    
    public Mono<String> enhanceProductDescription(String originalDescription) {
        var promptTemplate = """
            Enhance this product description to be more appealing:
            
            {{$input}}
            
            Make it concise, engaging, and highlight key features.
            """;
        
        var function = kernel.createSemanticFunction(
            promptTemplate,
            "enhanceDescription",
            null
        );
        
        return Mono.fromFuture(
            function.invokeAsync(originalDescription, kernel)
                .thenApply(result -> result.getResult())
        ).doOnError(error -> 
            logger.error("AI enhancement failed", error)
        );
    }
}
```

### 6.3 Prompt Engineering Best Practices

- **Clear instructions**: be explicit about format, tone, and constraints
- **Few-shot learning**: provide examples when needed
- **Context management**: limit context size; summarize when necessary
- **Error handling**: always handle AI service failures gracefully
- **Cost awareness**: log token usage; implement rate limiting
- **Testing**: mock Kernel in tests; use deterministic responses

### 6.4 AI Integration Testing

```java
@SpringBootTest
class AiEnhancementServiceTest {
    
    @MockBean
    private Kernel kernel;
    
    @Autowired
    private AiEnhancementService service;
    
    @Test
    void shouldEnhanceDescription() {
        // Arrange
        String input = "Blue jeans";
        String expected = "Premium blue jeans crafted from durable denim";
        
        var mockFunction = mock(SKFunction.class);
        var mockResult = mock(SKFunctionResult.class);
        
        when(kernel.createSemanticFunction(anyString(), anyString(), any()))
            .thenReturn(mockFunction);
        when(mockFunction.invokeAsync(eq(input), eq(kernel)))
            .thenReturn(CompletableFuture.completedFuture(mockResult));
        when(mockResult.getResult()).thenReturn(expected);
        
        // Act & Assert
        StepVerifier.create(service.enhanceProductDescription(input))
            .expectNext(expected)
            .verifyComplete();
    }
}
```

---

## 7) Security, Privacy, Compliance

- **Secrets management**: 
  - Never hardcode API keys, passwords, or tokens
  - Use Spring Boot's externalized configuration
  - Environment variables for local dev: `${OPENAI_API_KEY}`
  - Production: Spring Cloud Config, HashiCorp Vault, AWS Secrets Manager
  
- **Input validation**:
  - Validate all user input with JSR-380 annotations
  - Sanitize data before sending to AI services
  - Implement size limits on uploads and request bodies
  
- **Authentication & Authorization**:
  - Spring Security for AuthN/AuthZ
  - OAuth2/OIDC for identity
  - Method-level security with `@PreAuthorize`
  
- **Cryptography**:
  - Use `java.security` and Bouncy Castle for crypto
  - Never implement custom encryption algorithms
  - Use strong algorithms (AES-256, RSA-2048+)
  
- **PII handling**:
  - Avoid logging sensitive data
  - Redact PII in logs and error messages
  - Comply with GDPR/CCPA requirements
  
- **Dependency security**:
  - Regularly update dependencies
  - Use OWASP Dependency Check or Snyk
  - Monitor CVEs for used libraries

---

## 8) Testing Strategy

### 8.1 Unit Tests
```java
@ExtendWith(MockitoExtension.class)
class ItemServiceTest {
    
    @Mock
    private ItemRepository repository;
    
    @InjectMocks
    private ItemService service;
    
    @Test
    void shouldReturnItemWhenExists() {
        // Arrange
        var expectedItem = new ItemDetail("123", "Test Item", 
            BigDecimal.valueOf(29.99));
        when(repository.findById("123"))
            .thenReturn(Mono.just(expectedItem));
        
        // Act & Assert
        StepVerifier.create(service.getItemById("123"))
            .expectNext(expectedItem)
            .verifyComplete();
    }
    
    @Test
    void shouldThrowExceptionWhenItemNotFound() {
        when(repository.findById("999")).thenReturn(Mono.empty());
        
        StepVerifier.create(service.getItemById("999"))
            .expectError(ItemNotFoundException.class)
            .verify();
    }
}
```

### 8.2 Integration Tests
```java
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@Testcontainers
class ItemIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16")
        .withDatabaseName("testdb");
    
    @Autowired
    private WebTestClient webClient;
    
    @Test
    void shouldCreateAndRetrieveItem() {
        var createRequest = new CreateItemRequest("New Item", BigDecimal.valueOf(19.99));
        
        webClient.post()
            .uri("/api/items")
            .contentType(MediaType.APPLICATION_JSON)
            .bodyValue(createRequest)
            .exchange()
            .expectStatus().isCreated()
            .expectBody(ItemDetail.class)
            .value(item -> {
                assertThat(item.name()).isEqualTo("New Item");
                assertThat(item.price()).isEqualTo(BigDecimal.valueOf(19.99));
            });
    }
}
```

### 8.3 Test Conventions

- **Naming**: `methodName_whenCondition_thenExpectedBehavior`
- **AAA pattern**: Arrange, Act, Assert
- **Test data**: use builders or test fixtures
- **Mocking**: prefer Mockito; mock external dependencies only
- **Coverage**: aim for 80%+ on business logic; 100% on critical paths
- **Reactor testing**: use `StepVerifier` for reactive flows

---

## 9) Logging & Observability

### 9.1 Structured Logging

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import net.logstash.logback.marker.Markers;

@Service
public class OrderService {
    
    private static final Logger logger = LoggerFactory.getLogger(OrderService.class);
    
    public Mono<Order> processOrder(String orderId) {
        logger.info("Processing order: {}", orderId);
        
        return orderRepository.findById(orderId)
            .doOnSuccess(order -> {
                var markers = Markers.append("orderId", orderId)
                    .and(Markers.append("amount", order.totalAmount()));
                logger.info(markers, "Order processed successfully");
            })
            .doOnError(error -> 
                logger.error("Failed to process order: {}", orderId, error));
    }
}
```

### 9.2 OpenTelemetry Integration

- Use Spring Boot Actuator for metrics and health checks
- Integrate OpenTelemetry for distributed tracing
- Export traces to Jaeger, Zipkin, or cloud providers
- Add custom spans for AI operations to track performance

---

## 10) Build & Dependency Management

### 10.1 Maven Configuration

```xml
<project>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
    </parent>
    
    <properties>
        <java.version>21</java.version>
        <semantic-kernel.version>1.0.0</semantic-kernel.version>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-webflux</artifactId>
        </dependency>
        <dependency>
            <groupId>com.microsoft.semantic-kernel</groupId>
            <artifactId>semantic-kernel</artifactId>
            <version>${semantic-kernel.version}</version>
        </dependency>
    </dependencies>
</project>
```

### 10.2 Dependency Guidelines

- **Minimize dependencies**: use Spring Boot starters
- **Version management**: use dependency management from parent POM
- **Security**: run `mvn dependency:tree` and audit regularly
- **Updates**: keep dependencies current; test before upgrading
- **Justify additions**: document why each dependency is needed

### 10.3 Build Commands

```bash
# Compile
mvn clean compile

# Run tests
mvn test

# Integration tests
mvn verify

# Run application
mvn spring-boot:run

# Package
mvn clean package

# Skip tests (only for local experimentation)
mvn clean package -DskipTests
```

---

## 11) Performance & Optimization

- **Measure first**: use JMH for microbenchmarks
- **Reactive efficiency**: avoid unnecessary `.map()` chains; use `.transform()` for reusable operators
- **Connection pooling**: configure HikariCP for JDBC, R2DBC connection pools
- **Caching**: use Spring Cache abstraction with Redis or Caffeine
- **Virtual threads**: leverage Project Loom for high-concurrency blocking I/O
- **Memory management**: monitor heap usage; tune GC settings for workload

```java
@Configuration
@EnableCaching
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager() {
        return new ConcurrentMapCacheManager("items", "stock");
    }
}

@Service
public class ItemService {
    
    @Cacheable(value = "items", key = "#itemId")
    public Mono<ItemDetail> getItemById(String itemId) {
        // expensive operation
    }
}
```

---

## 12) Code Quality Standards

### 12.1 EditorConfig Compliance

- **Indentation**: 4 spaces (never tabs)
- **Line length**: 120 characters maximum
- **Line endings**: LF (Unix-style)
- **Character encoding**: UTF-8
- **Trailing whitespace**: remove
- **Final newline**: always include

### 12.2 Code Style Guidelines

- **Package naming**: lowercase, reverse domain (e.g., `com.bestseller.ai.service`)
- **Class naming**: PascalCase (e.g., `ItemService`, `OrderController`)
- **Method naming**: camelCase, verb-based (e.g., `getItem`, `processOrder`)
- **Constant naming**: UPPER_SNAKE_CASE (e.g., `MAX_RETRY_COUNT`)
- **Field naming**: camelCase (avoid Hungarian notation)

### 12.3 Static Analysis

- Enable compiler warnings: `-Xlint:all`
- Use SpotBugs for bug detection
- Optional: Checkstyle for style enforcement
- Optional: PMD for code quality rules

---

## 13) Definition of Done (Agent must include in PR summaries)

- [ ] Scope matched; acceptance criteria met
- [ ] Code compiles; all tests pass; no warnings
- [ ] Unit tests cover happy path + edge cases + error scenarios
- [ ] Integration tests verify end-to-end functionality
- [ ] Public APIs documented with Javadoc
- [ ] Breaking changes noted and migration path provided
- [ ] Structured logging implemented; no secrets in logs
- [ ] Configuration externalized; environment variables documented
- [ ] Security review: inputs validated; dependencies audited
- [ ] Performance acceptable for expected load
- [ ] EditorConfig compliance verified
- [ ] Semantic Kernel patterns followed for AI features
- [ ] Error handling comprehensive with meaningful messages

---

## 14) Common Tasks & Expected Agent Outputs

### Create a REST endpoint
- Route/controller design, DTOs, validation, service layer, repository, error handling, OpenAPI annotations, tests, curl examples

### Add an external API call
- WebClient configuration, resilience patterns (retry, circuit breaker), DTOs, error handling, tests with WireMock or MockWebServer

### Introduce database persistence
- Entity/record definition, repository interface, service layer, migrations (Flyway/Liquibase), integration tests with Testcontainers

### Implement AI feature with Semantic Kernel
- Kernel configuration, prompt templates, semantic functions, error handling, token usage logging, mocked tests, cost considerations

### Add reactive stream processing
- Flux/Mono operators, backpressure handling, error recovery, subscription patterns, StepVerifier tests

---

## 15) Red Flags to Avoid

- **Blocking in reactive chains**: never use `.block()` in production code
- **Uncontrolled threading**: avoid manual thread creation; use Spring's task executors
- **God classes**: keep classes focused; single responsibility principle
- **Null abuse**: prefer `Optional<T>` over null returns
- **Exception swallowing**: always log or propagate exceptions
- **Reflection abuse**: prefer compile-time safety; use reflection only when necessary
- **String concatenation for SQL**: always use parameterized queries
- **Stateful singletons**: singleton beans must be thread-safe
- **Hardcoded config**: externalize all environment-specific values
- **Missing timeouts**: always set timeouts for external calls

---

## 16) Resources & References

### Official Documentation
- [Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Spring Framework Documentation](https://docs.spring.io/spring-framework/docs/current/reference/html/)
- [Project Reactor Reference](https://projectreactor.io/docs/core/release/reference/)
- [Microsoft Semantic Kernel Java](https://learn.microsoft.com/en-us/semantic-kernel/java/)

### Best Practices
- [Spring Boot Best Practices](https://www.baeldung.com/spring-boot)
- [Reactive Programming Best Practices](https://www.vinsguru.com/reactor-best-practices/)
- [Java 21 Features](https://openjdk.org/projects/jdk/21/)

---

## Final Notes for the Agent

- **Present the Plan first**, then implement and test in small steps
- **Prefer official Spring patterns** and secure, observable implementations
- **Be explicit** about configuration keys, environment variables, and how to run things
- **Keep changes minimal**, composable, and aligned with this repository's conventions
- **Focus on correctness, security, and maintainability** over premature optimization
