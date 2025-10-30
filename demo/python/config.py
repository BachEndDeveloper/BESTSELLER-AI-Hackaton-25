"""Configuration settings for the application."""

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # Azure OpenAI Configuration
    azure_openai_api_key: str = Field(
        default="YOUR_AZURE_OPENAI_API_KEY_HERE",
        description="Azure OpenAI API key",
    )
    azure_openai_endpoint: str = Field(
        default="https://your-resource-name.openai.azure.com/",
        description="Azure OpenAI endpoint URL",
    )
    azure_openai_deployment_name: str = Field(
        default="gpt-4",
        description="Azure OpenAI deployment/model name",
    )
    azure_openai_api_version: str = Field(
        default="2024-02-15-preview",
        description="Azure OpenAI API version",
    )

    # Application Configuration
    app_title: str = "BESTSELLER AI Demo API"
    app_description: str = (
        "Demo API showcasing Semantic Kernel integration with Azure OpenAI"
    )
    app_version: str = "1.0.0"


settings = Settings()
