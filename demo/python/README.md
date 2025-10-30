# BESTSELLER AI Demo - Python FastAPI

A simple backend demo using FastAPI and Microsoft Semantic Kernel to interact with Azure OpenAI.

## Overview

This demo showcases:
- **FastAPI** web framework for building the REST API
- **Microsoft Semantic Kernel** for LLM orchestration
- **Azure OpenAI** integration for chat capabilities
- **Kernel Functions** for querying items, stock, and tracking information
- Static data models representing a fashion retail catalog

## Features

- **Chat Endpoint** (`/chat`) - Natural language interface powered by Azure OpenAI
- **Direct API Endpoints** - Traditional REST endpoints for items, stock, and tracking
- **Semantic Kernel Plugin** - Custom functions for data retrieval
- **Function Calling** - AI automatically calls appropriate functions based on user questions

## Prerequisites

- Python 3.11 or higher
- pip (Python package manager)
- Azure OpenAI account with API access (or placeholder for demo)

## Quick Start

Use the quickstart script for automated setup:

```bash
./quickstart.sh
```

This will:
- Create a virtual environment
- Install all dependencies
- Create a `.env` file from the example
- Run tests to verify everything works
- Show example usage

## Manual Installation

1. **Create a virtual environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Configure Azure OpenAI credentials**:
   
   Create a `.env` file in this directory with your Azure OpenAI credentials:
   ```env
   AZURE_OPENAI_API_KEY=your-api-key-here
   AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com/
   AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4
   AZURE_OPENAI_API_VERSION=2024-02-15-preview
   ```

   **Note**: For demo purposes, placeholder values are set in `config.py`. You need valid credentials to use the chat functionality.

## Running the Application

Start the FastAPI server:

```bash
python main.py
```

Or use uvicorn directly:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`

## API Documentation

Once running, visit:
- **Interactive API docs (Swagger)**: http://localhost:8000/docs
- **Alternative API docs (ReDoc)**: http://localhost:8000/redoc

## Endpoints

### Chat Endpoint

**POST** `/chat`

Send natural language messages to interact with the AI assistant.

**Request**:
```json
{
  "message": "What items do you have?"
}
```

**Response**:
```json
{
  "response": "We have the following items available: Classic T-Shirt ($29.99), Denim Jeans ($79.99), Summer Dress ($49.99), Leather Jacket ($199.99), and Running Sneakers ($89.99)."
}
```

**Example Questions**:
- "What items do you have?"
- "Tell me about item-001"
- "What's the stock status of item-002?"
- "Is the Classic T-Shirt in stock?"
- "Track shipment TRK-2025-001234"
- "What's the status of tracking number TRK-2025-001235?"

### Direct API Endpoints

**GET** `/items` - Get all items  
**GET** `/items/{item_id}` - Get specific item details  
**GET** `/stock/{item_id}` - Get stock information  
**GET** `/track/{tracking_no}` - Get tracking status  

## Example Usage

Run the example script to see available data and sample API calls:

```bash
python3 example_usage.py
```

### Using cURL

```bash
# Health check
curl http://localhost:8000/health

# Get all items
curl http://localhost:8000/items

# Get specific item
curl http://localhost:8000/items/item-001

# Get stock info
curl http://localhost:8000/stock/item-001

# Get tracking info
curl http://localhost:8000/track/TRK-2025-001234

# Chat with AI
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "What items do you have?"}'
```

### Using Python

```python
import requests

# Chat example
response = requests.post(
    "http://localhost:8000/chat",
    json={"message": "Tell me about item-001"}
)
print(response.json()["response"])
```

## Project Structure

```
demo/python/
├── main.py             # FastAPI application and endpoints
├── config.py           # Configuration and settings
├── models.py           # Data models and static data
├── plugin.py           # Semantic Kernel plugin with functions
├── requirements.txt    # Python dependencies
├── test_data.py        # Test script for data models
├── example_usage.py    # Example usage and API calls
├── quickstart.sh       # Quick start script
├── .env.example        # Example environment variables
├── .env                # Environment variables (create this)
├── .gitignore          # Git ignore rules
└── README.md           # This file
```

## Data Models

### Items
- `item-001`: Classic T-Shirt - $29.99
- `item-002`: Denim Jeans - $79.99
- `item-003`: Summer Dress - $49.99
- `item-004`: Leather Jacket - $199.99
- `item-005`: Running Sneakers - $89.99

### Stock Information
Each item has stock information including:
- In-stock status
- Available quantity
- Warehouse location
- Last updated timestamp

### Tracking Numbers
- `TRK-2025-001234`: In Transit
- `TRK-2025-001235`: Delivered
- `TRK-2025-001236`: Out for Delivery

## Semantic Kernel Integration

The application uses Microsoft Semantic Kernel to:

1. **Connect to Azure OpenAI** - Chat completion service
2. **Define Functions** - Kernel functions for data retrieval
3. **Enable Function Calling** - AI automatically invokes functions
4. **Process Responses** - Natural language responses based on data

### Available Kernel Functions

- `get_all_items`: List all items in the catalog
- `get_item_details`: Get detailed info about a specific item
- `get_stock_info`: Check stock availability
- `get_tracking_status`: Track shipment status
- `search_items_by_name`: Search items by name

## Development

### Code Style

This project follows Python best practices:
- PEP 8 style guide
- Type hints throughout
- Docstrings for all functions
- Black formatter (88 character line length)

### Linting

```bash
# Install development dependencies
pip install black ruff mypy

# Format code
black .

# Lint code
ruff check .

# Type check
mypy .
```

## Troubleshooting

### Azure OpenAI Connection Issues

If you see errors related to Azure OpenAI:
1. Verify your `.env` file has correct credentials
2. Check that your Azure OpenAI deployment is active
3. Ensure your API key has not expired
4. Verify the deployment name matches your Azure resource

### Import Errors

If you get import errors:
1. Ensure virtual environment is activated
2. Install all dependencies: `pip install -r requirements.txt`
3. Check Python version is 3.11+

### Port Already in Use

If port 8000 is already in use:
```bash
# Use a different port
uvicorn main:app --port 8001
```

## Next Steps

To extend this demo:

1. **Add Database**: Replace static data with PostgreSQL (see `scripts/` directory)
2. **Add Authentication**: Implement API key or OAuth authentication
3. **Enhanced AI Features**: Add more sophisticated prompts and functions
4. **Streaming Responses**: Implement streaming for chat responses
5. **Caching**: Add Redis caching for frequently accessed data
6. **Rate Limiting**: Implement rate limiting for the chat endpoint

## Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Microsoft Semantic Kernel](https://learn.microsoft.com/en-us/semantic-kernel/)
- [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
- [Pydantic Documentation](https://docs.pydantic.dev/)

## License

MIT License - see repository root for details.
