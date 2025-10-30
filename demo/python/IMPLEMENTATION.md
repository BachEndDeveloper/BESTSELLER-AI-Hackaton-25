# Python Demo - Implementation Summary

## Overview

This demo showcases a complete FastAPI backend with Microsoft Semantic Kernel integration for AI-powered chat capabilities. The implementation follows the BESTSELLER AI Hackathon theme of a fashion retail catalog system.

## Architecture

```
┌─────────────────┐
│   FastAPI App   │
│    (main.py)    │
└────────┬────────┘
         │
         ├──────────────────┐
         │                  │
    ┌────▼────┐      ┌─────▼──────┐
    │ Chat    │      │ Direct API │
    │Endpoint │      │ Endpoints  │
    └────┬────┘      └─────┬──────┘
         │                 │
    ┌────▼─────────────────▼───┐
    │   Semantic Kernel        │
    │  (Azure OpenAI)          │
    └──────────┬───────────────┘
               │
    ┌──────────▼───────────────┐
    │  BestsellerPlugin        │
    │  (Kernel Functions)      │
    └──────────┬───────────────┘
               │
    ┌──────────▼───────────────┐
    │   Static Data Models     │
    │  (Items/Stock/Tracking)  │
    └──────────────────────────┘
```

## Key Components

### 1. FastAPI Application (`main.py`)

**Endpoints:**
- `POST /chat` - Natural language chat interface with AI
- `GET /items` - List all items
- `GET /items/{item_id}` - Get item details
- `GET /stock/{item_id}` - Get stock information
- `GET /track/{tracking_no}` - Get tracking status
- `GET /health` - Health check
- `GET /` - Root endpoint with API info

**Features:**
- CORS enabled for cross-origin requests
- Structured logging
- Error handling with proper HTTP status codes
- Automatic OpenAPI documentation (Swagger/ReDoc)

### 2. Semantic Kernel Integration

**Configuration:**
- Service: Azure OpenAI Chat Completion
- Deployment: Configurable via environment variables
- API Version: 2024-02-15-preview (configurable)
- Function Calling: Auto mode (AI decides when to call functions)

**Chat Flow:**
1. User sends message to `/chat`
2. System message sets AI assistant context
3. Kernel processes message with function calling enabled
4. AI automatically invokes relevant plugin functions
5. Response generated based on function results

### 3. Kernel Plugin (`plugin.py`)

**Functions:**

| Function | Description | Parameters | Returns |
|----------|-------------|------------|---------|
| `get_all_items` | List all items | None | JSON array of items |
| `get_item_details` | Get item details | `item_id` | JSON object with full details |
| `get_stock_info` | Check stock | `item_id` | JSON object with stock info |
| `get_tracking_status` | Track shipment | `tracking_no` | JSON object with tracking |
| `search_items_by_name` | Search items | `search_term` | JSON array of matches |

All functions return JSON strings that the AI can parse and use to generate natural language responses.

### 4. Data Models (`models.py`)

**Classes:**
- `ItemSummary` - Basic item info (id, name, price)
- `ItemDetail` - Full item details (includes description, category, brand, SKU)
- `StockInfo` - Stock availability (in_stock, quantity, warehouse, last_updated)
- `TrackingInfo` - Shipment tracking (status, location, delivery dates)
- `TrackingEvent` - Individual tracking event (timestamp, location, status, description)

**Static Data:**
- 5 fashion items (t-shirt, jeans, dress, jacket, sneakers)
- Stock records for all items (mix of in-stock and out-of-stock)
- 3 tracking numbers with full history

### 5. Configuration (`config.py`)

Uses Pydantic Settings for type-safe configuration:
- Environment variable loading from `.env` file
- Validation of required fields
- Default placeholder values for demo mode
- Support for custom API versions and deployments

**Environment Variables:**
- `AZURE_OPENAI_API_KEY`
- `AZURE_OPENAI_ENDPOINT`
- `AZURE_OPENAI_DEPLOYMENT_NAME`
- `AZURE_OPENAI_API_VERSION`

## Example Interactions

### Chat Examples

**User:** "What items do you have?"

**AI Response:** Uses `get_all_items()` function and responds:
> "We have the following items available: Classic T-Shirt ($29.99), Denim Jeans ($79.99), Summer Dress ($49.99), Leather Jacket ($199.99), and Running Sneakers ($89.99)."

**User:** "Is item-002 in stock?"

**AI Response:** Uses `get_stock_info("item-002")` and responds:
> "I'm sorry, but the Denim Jeans (item-002) is currently out of stock. We have 0 units available at the Main Warehouse in Copenhagen."

**User:** "Where is my package TRK-2025-001234?"

**AI Response:** Uses `get_tracking_status("TRK-2025-001234")` and responds:
> "Your package (TRK-2025-001234) is currently In Transit at the Distribution Center in Copenhagen. The estimated delivery date is November 2, 2025 at 18:00 UTC."

### Direct API Examples

```bash
# Get all items
curl http://localhost:8000/items

# Response:
{
  "items": [
    {"item_id": "item-001", "name": "Classic T-Shirt", "price": 29.99},
    {"item_id": "item-002", "name": "Denim Jeans", "price": 79.99},
    ...
  ]
}

# Get item details
curl http://localhost:8000/items/item-001

# Response:
{
  "item_id": "item-001",
  "name": "Classic T-Shirt",
  "price": 29.99,
  "description": "A comfortable cotton t-shirt...",
  "category": "Apparel",
  "brand": "BESTSELLER",
  "sku": "BST-TS-001"
}
```

## Testing

### Manual Testing

Run the test script:
```bash
python3 test_data.py
```

This validates:
- All data models can be imported
- Static data is properly structured
- Plugin functions work correctly (if dependencies installed)

Run the example usage:
```bash
python3 example_usage.py
```

This displays:
- All available items
- Stock information
- Tracking data
- Example API calls
- Sample chat questions

### Running the Server

```bash
# Using the main script
python3 main.py

# Or using uvicorn directly
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Then test with:
```bash
# Health check
curl http://localhost:8000/health

# Interactive docs
open http://localhost:8000/docs
```

## Dependencies

### Core Dependencies
- `fastapi>=0.104.0` - Modern web framework
- `uvicorn[standard]>=0.24.0` - ASGI server
- `pydantic>=2.5.0` - Data validation
- `pydantic-settings>=2.1.0` - Settings management
- `semantic-kernel>=1.0.0` - Microsoft AI orchestration
- `python-dotenv>=1.0.0` - Environment variable loading

### Semantic Kernel Sub-dependencies
- Azure OpenAI connectors
- Function calling support
- Chat completion capabilities

## Security Considerations

1. **API Keys**: Never commit `.env` file with real credentials
2. **Input Validation**: All endpoints validate input data
3. **Error Messages**: Don't expose sensitive information
4. **CORS**: Currently allows all origins (restrict in production)
5. **Rate Limiting**: Not implemented (add for production)

## Production Readiness Checklist

To make this production-ready:

- [ ] Add authentication/authorization
- [ ] Implement rate limiting
- [ ] Add request/response logging
- [ ] Integrate with real database (PostgreSQL)
- [ ] Add caching layer (Redis)
- [ ] Implement proper secret management
- [ ] Add monitoring and alerting
- [ ] Set up CI/CD pipeline
- [ ] Add comprehensive test suite
- [ ] Configure CORS properly
- [ ] Add API versioning
- [ ] Implement pagination for list endpoints
- [ ] Add request validation middleware
- [ ] Set up error tracking (e.g., Sentry)
- [ ] Add API documentation generation

## Extensibility

### Adding New Kernel Functions

1. Define function in `plugin.py`:
```python
@kernel_function(
    name="your_function_name",
    description="Clear description for AI to understand when to use this"
)
def your_function(
    self,
    param: Annotated[str, "Parameter description"]
) -> Annotated[str, "Return type description"]:
    # Implementation
    return json.dumps(result)
```

2. The AI will automatically discover and use it when appropriate

### Adding New Data

1. Add data structures to `models.py`
2. Update plugin functions to access new data
3. Update API endpoints in `main.py` if needed

### Switching LLM Providers

To use different AI providers:
1. Update imports in `main.py`
2. Change service initialization in `create_kernel()`
3. Update configuration in `config.py`

## Performance Notes

- Static data is in-memory (instant access)
- Each chat request makes 1 API call to Azure OpenAI
- Function calls are local (no additional API calls)
- FastAPI is async (handles concurrent requests efficiently)
- No database queries (pure in-memory for demo)

## Monitoring and Debugging

Enable debug logging:
```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

Check logs for:
- Kernel initialization
- Chat requests
- Function calls made by AI
- Error messages

## Common Issues

1. **Import Errors**: Ensure virtual environment is activated
2. **Connection Errors**: Check Azure OpenAI credentials in `.env`
3. **Function Not Called**: Verify function description is clear
4. **Timeout Errors**: Check network connection and API endpoint

## Future Enhancements

Potential improvements:
- Streaming responses for real-time chat
- Conversation history/context management
- Multi-turn conversations with memory
- User profiles and preferences
- Advanced search with filters
- Recommendation engine
- Image generation for products
- Voice interface support
- Multi-language support
- Analytics and insights

## License

MIT License - see repository root for details.
