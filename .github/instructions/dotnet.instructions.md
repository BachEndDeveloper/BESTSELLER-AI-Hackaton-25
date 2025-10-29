---
applyTo: "**/dotnet/*"
---
!-- Save as: dotnet.instructions.md  (recommended path: .github/dotnet.instructions.md) -->
# GitHub Copilot Agent — .NET/C# Repository Instructions

**Audience:** GitHub Copilot (Agent mode), maintainers, contributors  
**Purpose:** Guide the Agent to generate secure, correct, maintainable .NET code and collaborate effectively with humans.  
**Scope:** C#/.NET services, libraries, and tooling in this repository.

---

## 0) Agent Behavior (must follow)

1. **Confirm scope & success criteria** in 3–7 bullets before coding (inputs/outputs, constraints, acceptance checks). Keep it brief; do **not** reveal internal chain-of-thought.
2. **Propose a plan**: files to add/modify, tests, and exact CLI commands to build/test/format.
3. **Change in small slices** (≤ ~150 LOC per file change). Prefer incremental PRs that compile and pass tests.
4. **Generate tests first or alongside code**; cover happy paths, key edge cases, errors/timeouts, and cancellation.
5. **Explain what & why (concise)**: assumptions, chosen patterns, trade‑offs. Link to official docs if suggesting unfamiliar APIs.
6. **Observe repo conventions** (formatting, analyzers, DI, logging, error shape). Align with existing patterns over introducing new ones.
7. **Security first**: no secrets or PII in code or logs; validate inputs; use platform crypto; apply HTTP resiliency.
8. **No speculative dependencies**: justify any new package with benefit, security posture, and footprint.

**Do not:**

- Copy code from the web; generate original code.  
- Hard‑code secrets/URLs; use configuration and secret stores.  
- Block on async (`.Result`, `.Wait()`), or fire‑and‑forget without handling.  
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

- **Target framework:** latest **LTS** (currently `net8.0`). Prepare an upgrade path when the next LTS arrives.
- **Layout**!-- Save as: dotnet.instructions.md  (recommended path: .github/dotnet.instructions.md) -->

# GitHub Copilot Agent — .NET/C# Repository Instructions

**Audience:** GitHub Copilot (Agent mode), maintainers, contributors  
**Purpose:** Guide the Agent to generate secure, correct, maintainable .NET code and collaborate effectively with humans.  
**Scope:** C#/.NET services, libraries, and tooling in this repository.

---

## 0) Agent Behavior (must follow)

1. **Confirm scope & success criteria** in 3–7 bullets before coding (inputs/outputs, constraints, acceptance checks). Keep it brief; do **not** reveal internal chain-of-thought.
2. **Propose a plan**: files to add/modify, tests, and exact CLI commands to build/test/format.
3. **Change in small slices** (≤ ~150 LOC per file change). Prefer incremental PRs that compile and pass tests.
4. **Generate tests first or alongside code**; cover happy paths, key edge cases, errors/timeouts, and cancellation.
5. **Explain what & why (concise)**: assumptions, chosen patterns, trade‑offs. Link to official docs if suggesting unfamiliar APIs.
6. **Observe repo conventions** (formatting, analyzers, DI, logging, error shape). Align with existing patterns over introducing new ones.
7. **Security first**: no secrets or PII in code or logs; validate inputs; use platform crypto; apply HTTP resiliency.
8. **No speculative dependencies**: justify any new package with benefit, security posture, and footprint.

**Do not:**

- Copy code from the web; generate original code.  
- Hard‑code secrets/URLs; use configuration and secret stores.  
- Block on async (`.Result`, `.Wait()`), or fire‑and‑forget without handling.  
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

- **Target framework:** latest version (currently `net9.0`). Stay on the latest version, no matter if **STS** or **LTS**. Prepare an upgrade path when the next version arrives.
- **Layout**
/src/
/tests/

- **Nullability:** **Enabled** (`<Nullable>enable</Nullable>`).  
- **Warnings as errors** in CI for production projects.  
- **Testing:** xUnit + FluentAssertions (or project standard). Coverage via coverlet.  
- **Formatting & analysis:** `dotnet format`, .editorconfig, Roslyn analyzers; StyleCop and CodeQL optional.  
- **DI & hosting:** `Microsoft.Extensions.Hosting`, `Microsoft.Extensions.DependencyInjection`.  
- **Configuration:** `appsettings.json` + env overrides + `IOptions<T>`; local secrets via User Secrets; production via a managed secret store.

> If the repository differs, detect and follow *existing* patterns.

---

## 3) AI‑Assisted Development Best Practices

- **Clarify**: Restate the problem and edge cases before proposing code.  
- **Design sketch**: Show brief contracts/DTOs/routes before large changes.  
- **Offer options when impactful** (e.g., EF Core vs. Dapper) and recommend one with trade‑offs.  
- **Verify**: Include tests and commands. Provide a smoke test (CLI/curl) for endpoints.  
- **License hygiene**: Original code only; short snippets mirroring official docs must be cited.  
- **Team fit**: Reuse abstractions, logging categories, ProblemDetails error shape, and folder structure.

---

## 4) C# Language Guidance (modern idioms)

- **Immutability by default**: prefer `record`/`record struct`, `init` setters, `readonly` fields.  
- **Async everywhere**: `Task`/`ValueTask`, `IAsyncEnumerable<T>`, `await using` for `IAsyncDisposable`. No sync-over-async.  
- **Cancellation**: public async APIs accept `CancellationToken` and propagate it.  
- **Null safety**: guard public inputs (`ArgumentNullException.ThrowIfNull(x);`).  
- **Exceptions**: use for exceptional paths; include context (no secrets).  
- **LINQ**: avoid eager `ToList()` unless needed; be mindful of large enumerations.  
- **High‑perf paths**: consider `Span<T>`, `ReadOnlySpan<T>`, pooling (`ArrayPool<T>`).  
- **Time & randomness**: UTC (`DateTimeOffset` or NodaTime `Instant`); `Random.Shared`.  
- **Modern features**: pattern matching, primary constructors, file‑scoped namespaces.

---

## 5) .NET Platform Guidance

### 5.1 Hosting, DI, Configuration

- Prefer minimal APIs for small services;
    - Advice on controller if services/api surface grows complex.
- Perfer .Net Aspire
- Use the Generic Host:

```csharp
var builder = Host.CreateApplicationBuilder(args);
```
- Options pattern with validation:

```csharp
builder.Services
    .AddOptions<MyOptions>()
    .Bind(builder.Configuration.GetSection("MyOptions"))
    .ValidateDataAnnotations()
    .ValidateOnStart();
```
- DI lifetimes: default Scoped for request work; Singleton only for stateless and thread‑safe; Transient for lightweight, stateless services.

### 5.2 Logging & Observability
- Use ILogger<T> with structured logs:

```csharp
_logger.LogInformation("Processed {Count} items", count);
```
- Avoid secrets/PII; map errors to ProblemDetails.
- Prefer OpenTelemetry (traces/metrics/logs); propagate trace IDs.

### 5.3 HTTP & Resiliency

- Always use IHttpClientFactory. Configure timeouts and policies (Polly):
    - Only implement specific Polly policies as needed, and if the project does not use .Net Aspire or already integrates Polly.

```csharp
builder.Services.AddHttpClient("ExternalApi", c =>
{
    c.BaseAddress = new Uri(builder.Configuration["ExternalApi:BaseUrl"]!);
    c.Timeout = TimeSpan.FromSeconds(10);
})
.AddTransientHttpErrorPolicy(p => p.WaitAndRetryAsync(3, i => TimeSpan.FromMilliseconds(200 * i)))
.AddTransientHttpErrorPolicy(p => p.CircuitBreakerAsync(5, TimeSpan.FromSeconds(30)));
```

### 5.4 Data Access
- EF Core defaults:
- DbContext: Scoped; not shared across threads.
- Use AsNoTracking() for reads; AsSplitQuery() to avoid cartesian explosion.
- Use compiled queries on hot paths; avoid N+1.
- Versioned migrations; keep seeding separate from schema.
- Dapper: use for high‑throughput, simple mappings; always parameterize SQL.

### 5.5 Web APIs
- Minimal APIs for small services; Controllers for larger/complex APIs.
- API versioning; input validation (e.g., FluentValidation).
- OpenAPI/Swagger enabled; annotate with XML docs.
- Standardized errors via ProblemDetails.

### 5.6 Performance & Reliability
- Measure before optimizing; use BenchmarkDotNet for hot paths.
- Avoid global locks; prefer async and fine‑grained concurrency.
- Dispose IDisposable/IAsyncDisposable correctly (await using).

⸻

## 6 Security, Privacy, Compliance
- Secrets: never in code/tests/logs. Use config providers and secret stores.
- Input: validate shape, ranges, lengths; enforce size limits and content types.
- AuthN/Z: OIDC/JWT where applicable; authorize at endpoints and data access.
- Crypto: use System.Security.Cryptography only; modern algorithms; authenticated encryption.
- Files/paths: sanitize; prefer streams; never load untrusted assemblies.
- Dependencies: minimize; audit with dotnet list package --vulnerable.
- PII: avoid logging; redact if unavoidable; comply with org/regulatory policy.

⸻

## 7 Testing Strategy
- Levels: unit → component → integration → smoke.
- Libraries: xUnit + FluentAssertions; test doubles or a lightweight mocking lib.
- Determinism: avoid time‑based flakiness; abstract time (ITimeProvider).
- Coverage: target critical logic & error handling; measure without gaming.

```csharp
public sealed class PriceCalculatorTests
{
    [Fact]
    public void Calculates_Discounted_Total()
    {
        var sut = new PriceCalculator(new TaxServiceStub(0.2m));
        var total = sut.Calculate(100m, discountRate: 0.10m);
        total.Should().Be(108m);
    }
}
```

8) Code Quality: Analyzers, Style, Structure
	•	Enable Roslyn analyzers; promote important rules to errors in CI.
	•	One type per file (except small records/enums).
	•	Small, focused methods; extract helpers.
	•	Public APIs documented with XML if reusable.

.editorconfig (baseline)
```
root = true

[*.{cs,csx}]
charset = utf-8
indent_style = space
indent_size = 4
end_of_line = lf
insert_final_newline = true

dotnet_sort_system_directives_first = true
dotnet_separate_import_directive_groups = true
csharp_prefer_braces = true:suggestion
csharp_style_var_for_built_in_types = true:suggestion
csharp_style_var_when_type_is_apparent = true:suggestion
csharp_style_var_elsewhere = true:suggestion
dotnet_style_qualification_for_field = false:suggestion
dotnet_style_qualification_for_property = false:suggestion
dotnet_style_null_propagation = true:suggestion

# Nullable reference types
dotnet_analyzer_diagnostic.severity = warning

# Naming: private fields with underscore
dotnet_naming_rule.private_fields_underscore.severity = suggestion
dotnet_naming_rule.private_fields_underscore.symbols = private_fields
dotnet_naming_rule.private_fields_underscore.style = underscore_prefix

dotnet_naming_symbols.private_fields.applicable_kinds = field
dotnet_naming_symbols.private_fields.applicable_accessibilities = private
dotnet_naming_style.underscore_prefix.required_prefix = _
dotnet_naming_style.underscore_prefix.capitalization = camel_case
```

## 8 Definition of Done (Agent must include in PR summaries)
- Scope matched; acceptance criteria met.
- Code builds; CI green; formatting/analyzers clean.
- Unit/integration tests cover happy path + key edge/error cases.
- Public APIs documented; breaking changes noted.
- Structured logging; secrets/PII not logged.
- Config externalized; sane defaults; options validated.
- Performance characteristics acceptable; no obvious hot paths unmeasured.
- Security review: inputs validated; HTTP calls resilient; dependencies minimal and audited.

⸻

## 9 Preferred Architectural Patterns
- Clean architecture boundaries (Domain, Application, Infrastructure, Web).
- Interface‑first for swappable infrastructure.
- CQRS when reads/writes diverge significantly.
- Middleware/pipelines for cross‑cutting concerns (auth, validation, observability).
- Mapping via lightweight mappers or source generators; avoid heavy reflection.

⸻

## 10 Common Tasks & Expected Agent Outputs

Create a REST endpoint for X
- Route design, request/response models, validation, DI registrations, error mapping (ProblemDetails), tests, and a curl example.

Add an external API call
- IHttpClientFactory registration, Polly policies, typed client, configuration keys, DTOs, fake/delegating handler tests.

Introduce persistence for Y
- EF Core DbContext, entity configuration, migrations, read/write patterns, sample queries, integration tests (in-memory or Testcontainers if available).

Refactor to async/cancellable
- Async signatures, CancellationToken propagation, no .Result/.Wait(), cancellation tests.

Improve performance of Z
- Measurement plan, benchmark (BenchmarkDotNet), justified optimizations with before/after numbers.

## 11 Red Flags to Avoid
- Blocking on async, unbounded concurrency, infinite retries.
- God classes and “Utils” catch‑alls.
- Overuse of reflection/dynamic when generics suffice.
- Swallowed exceptions or log spam.
- Building auth/crypto/serialization by hand when robust libraries exist.

## Final Notes for the Agent
	•	Present the Plan first, then implement and test in small steps.
	•	Prefer official .NET patterns and secure, observable implementations.
	•	Be explicit about configuration keys, environment variables, and how to run things.
	•	Keep changes minimal, composable, and aligned with this repository’s conventions.