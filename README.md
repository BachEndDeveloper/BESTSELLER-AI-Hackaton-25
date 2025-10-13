# BESTSELLER AI Hackathon 2025

Welcome to the BESTSELLER AI Hackathon repository! This repository provides starting templates and demo implementations for integrating AI capabilities into backend services using Microsoft's Semantic Kernel library.

## 🎯 Overview

This hackathon focuses on implementing AI features into API/backend services. Participants can choose from three technology stacks:
- **Java** with Spring Framework
- **.NET** with .NET Aspire  
- **Python** with FastAPI

All implementations use **Microsoft Semantic Kernel** as the primary library for LLM integration.

## 📁 Repository Structure

```
├── demo/          # Starting templates for participants
│   ├── java/        # Java Spring starter project
│   ├── dotnet/      # .NET Aspire starter project
│   └── python/      # Python FastAPI starter project
├── sample/            # Complete demo implementations
│   ├── java/        # Java Spring demo with AI integration
│   ├── dotnet/      # .NET Aspire demo with AI integration
│   └── python/      # Python FastAPI demo with AI integration
├── agents.md        # Best practices and guidelines for AI agents
└── README.md        # This file
```

Each language directory contains:
- `.editorconfig` - Code formatting and style configurations
- `README.md` - Language-specific setup and usage instructions
- Source code and project files

## 🚀 Getting Started

### Prerequisites

Choose your preferred technology stack and ensure you have the required tools installed:

#### For Java Development
- **Java 21+** (LTS recommended)
- **Maven 3.8+** or **Gradle 8+**
- IDE: IntelliJ IDEA, Eclipse, or VS Code with Java extensions

#### For .NET Development  
- **.NET 9 SDK**
- **.NET Aspire** workload (`dotnet workload install aspire`)
- IDE: Visual Studio 2022, VS Code, or JetBrains Rider

#### For Python Development
- **Python 3.11+**
- **pip** and **virtualenv** (or **conda**)
- IDE: PyCharm, VS Code, or any Python-compatible editor

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/BachEndDeveloper/BESTSELLER-AI-Hackaton-25.git
   cd BESTSELLER-AI-Hackaton-25
   ```

2. **Choose your path**
   - Navigate to `sample/<language>/` to start with a template
   - Navigate to `demo/<language>/` to see a complete implementation

3. **Follow language-specific instructions**
   - Check the README.md in your chosen language directory
   - Set up your development environment
   - Install dependencies and run the application

## 🔧 Technologies Used

### Core Technologies
- **Microsoft Semantic Kernel** - AI orchestration and LLM integration
- **OpenAI GPT Models** - Large Language Models for AI capabilities
- **RESTful APIs** - Standard API design patterns

### Technology Stacks

#### Java Stack
- **Java 21** - Latest LTS version with modern language features
- **Spring Boot 3.x** - Enterprise-grade application framework
- **Spring WebFlux** - Reactive programming support
- **Maven** - Dependency management and build tool

#### .NET Stack  
- **.NET 9** - Latest version with performance improvements
- **.NET Aspire** - Cloud-ready stack for distributed applications
- **ASP.NET Core** - High-performance web framework
- **Entity Framework Core** - Object-relational mapping

#### Python Stack
- **Python 3.11+** - Modern Python with performance enhancements
- **FastAPI** - High-performance, easy-to-use web framework
- **Pydantic** - Data validation using Python type annotations
- **Uvicorn** - Lightning-fast ASGI server

## 🏗️ Development Guidelines

### Code Quality
- Each language directory includes `.editorconfig` for consistent formatting
- Follow language-specific best practices (see `agents.md`)
- Use provided linting and formatting tools

### AI Integration Best Practices
- Use Semantic Kernel for all LLM interactions
- Implement proper error handling for AI operations
- Consider rate limiting and cost management
- Follow security best practices for API keys

### Project Structure
- Keep AI logic separated from business logic
- Use dependency injection patterns
- Implement proper logging and monitoring
- Write tests for both business logic and AI integrations

## 📖 Additional Resources

- **[Semantic Kernel Documentation](https://learn.microsoft.com/en-us/semantic-kernel/)** - Official Microsoft documentation
- **[Best Practices Guide](./agents.md)** - Detailed guidelines for development and AI agents
- **Language-specific READMEs** - Setup and usage instructions for each technology stack

## 🤝 Contributing

1. Choose your technology stack
2. Start with the sample project or use your own
3. Implement AI features using Semantic Kernel
4. Follow the coding standards in your chosen language directory
5. Test thoroughly and document your implementation

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 💡 Support

For questions and support during the hackathon:
- Check the language-specific README files
- Review the `agents.md` file for best practices
- Consult the demo implementations for reference

Happy hacking! 🚀
