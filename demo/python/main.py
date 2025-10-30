"""Main FastAPI application with Semantic Kernel integration."""

import logging
from typing import Any, Final

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from semantic_kernel import Kernel
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion
from semantic_kernel.connectors.ai.function_call_behavior import (
    FunctionCallBehavior,
)
from semantic_kernel.contents.chat_history import ChatHistory

from config import settings
from plugin import BestsellerPlugin

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

# Initialize FastAPI application
app = FastAPI(
    title=settings.app_title,
    description=settings.app_description,
    version=settings.app_version,
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Request/Response models
class ChatRequest(BaseModel):
    """Request model for chat endpoint."""

    message: str = Field(
        ...,
        min_length=1,
        max_length=2000,
        description="The user's message to the AI assistant",
    )


class ChatResponse(BaseModel):
    """Response model for chat endpoint."""

    response: str = Field(..., description="The AI assistant's response")


# Constants
SERVICE_ID: Final[str] = "azure_chat_completion"
SYSTEM_PROMPT: Final[str] = """You are a helpful assistant for BESTSELLER, a fashion retail company.
You can help customers with:
- Finding and browsing items in our catalog
- Checking stock availability for items
- Tracking shipments

Use the available functions to answer customer questions accurately.
Be friendly, concise, and helpful in your responses."""


# Initialize Semantic Kernel
def create_kernel() -> Kernel:
    """Create and configure a Semantic Kernel instance.
    
    Returns:
        Kernel: Configured kernel with Azure OpenAI service and BESTSELLER plugin.
    """
    kernel = Kernel()

    # Add Azure OpenAI chat completion service
    chat_service = AzureChatCompletion(
        service_id=SERVICE_ID,
        deployment_name=settings.azure_openai_deployment_name,
        endpoint=settings.azure_openai_endpoint,
        api_key=settings.azure_openai_api_key,
        api_version=settings.azure_openai_api_version,
    )
    kernel.add_service(chat_service)

    # Add the BESTSELLER plugin
    kernel.add_plugin(BestsellerPlugin(), plugin_name="bestseller")

    logger.info("Kernel initialized with Azure OpenAI and BESTSELLER plugin")
    return kernel


# Global kernel instance
kernel = create_kernel()


@app.get("/")
async def root() -> dict[str, str]:
    """Root endpoint."""
    return {
        "message": "BESTSELLER AI Demo API",
        "description": "Send POST requests to /chat to interact with the AI assistant",
    }


@app.get("/health")
async def health() -> dict[str, str]:
    """Health check endpoint."""
    return {"status": "healthy"}


@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest) -> ChatResponse:
    """
    Chat endpoint that processes user messages using Semantic Kernel.

    The AI assistant can answer questions about:
    - Items in the catalog
    - Stock availability
    - Tracking information

    Example questions:
    - "What items do you have?"
    - "Tell me about item-001"
    - "What's the stock status of item-002?"
    - "Track shipment TRK-2025-001234"
    
    Args:
        request: ChatRequest containing the user's message.
        
    Returns:
        ChatResponse: The AI assistant's response.
        
    Raises:
        HTTPException: If there's an error processing the request.
    """
    try:
        logger.info("Received chat request: %s", request.message)

        # Create a chat history
        chat_history = ChatHistory()

        # Add system message
        chat_history.add_system_message(SYSTEM_PROMPT)

        # Add user message
        chat_history.add_user_message(request.message)

        # Get the chat completion service
        chat_completion = kernel.get_service(service_id=SERVICE_ID)

        # Configure execution settings with function calling
        execution_settings = AzureChatCompletion.get_prompt_execution_settings_class()(
            function_call_behavior=FunctionCallBehavior.EnableFunctions(
                auto_invoke=True, filters={}
            )
        )

        # Get response from the kernel
        response = await chat_completion.get_chat_message_contents(
            chat_history=chat_history,
            settings=execution_settings,
            kernel=kernel,
        )

        # Extract the response text from the result
        response_text = str(response[0]) if response else "No response generated"
        logger.info("Generated response: %s", response_text)

        return ChatResponse(response=response_text)

    except Exception as e:
        logger.error("Error processing chat request: %s", str(e), exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Error processing request: {str(e)}",
        ) from e


@app.get("/items")
async def get_items() -> dict[str, Any]:
    """Get all items (direct API endpoint)."""
    from models import ITEMS

    items_list = [
        {"item_id": item.item_id, "name": item.name, "price": item.price}
        for item in ITEMS.values()
    ]
    return {"items": items_list}


@app.get("/items/{item_id}")
async def get_item(item_id: str) -> dict[str, Any]:
    """Get item details (direct API endpoint)."""
    from models import ITEMS

    item = ITEMS.get(item_id)
    if not item:
        raise HTTPException(status_code=404, detail=f"Item {item_id} not found")

    return {
        "item_id": item.item_id,
        "name": item.name,
        "price": item.price,
        "description": item.description,
        "category": item.category,
        "brand": item.brand,
        "sku": item.sku,
    }


@app.get("/stock/{item_id}")
async def get_stock(item_id: str) -> dict[str, Any]:
    """Get stock information (direct API endpoint)."""
    from models import STOCK

    stock = STOCK.get(item_id)
    if not stock:
        raise HTTPException(
            status_code=404, detail=f"Stock info for {item_id} not found"
        )

    return {
        "item_id": stock.item_id,
        "in_stock": stock.in_stock,
        "quantity": stock.quantity,
        "warehouse": stock.warehouse,
        "last_updated": stock.last_updated,
    }


@app.get("/track/{tracking_no}")
async def get_tracking(tracking_no: str) -> dict[str, Any]:
    """Get tracking information (direct API endpoint)."""
    from models import TRACKING

    tracking = TRACKING.get(tracking_no)
    if not tracking:
        raise HTTPException(
            status_code=404, detail=f"Tracking number {tracking_no} not found"
        )

    history = []
    if tracking.history:
        history = [
            {
                "timestamp": event.timestamp,
                "location": event.location,
                "status": event.status,
                "description": event.description,
            }
            for event in tracking.history
        ]

    return {
        "tracking_no": tracking.tracking_no,
        "status": tracking.status,
        "current_location": tracking.current_location,
        "estimated_delivery": tracking.estimated_delivery,
        "delivery_date": tracking.delivery_date,
        "history": history,
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
