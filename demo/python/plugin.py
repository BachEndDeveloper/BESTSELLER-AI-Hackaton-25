"""Semantic Kernel plugin for BESTSELLER data queries."""

import json
from typing import Annotated, Final

from semantic_kernel.functions import kernel_function

from models import ITEMS, STOCK, TRACKING


class BestsellerPlugin:
    """Plugin that provides functions to query BESTSELLER data.
    
    This plugin exposes kernel functions for:
    - Listing and searching items in the catalog
    - Retrieving detailed item information
    - Checking stock availability
    - Tracking shipments
    """

    @kernel_function(
        name="get_all_items",
        description="Get a list of all available items with their ID, name, and price",
    )
    def get_all_items(self) -> Annotated[str, "JSON array of all items"]:
        """Get all items in the catalog.
        
        Returns:
            str: JSON string containing an array of all items with id, name, and price.
        """
        items_list = [
            {"item_id": item.item_id, "name": item.name, "price": item.price}
            for item in ITEMS.values()
        ]
        return json.dumps(items_list, indent=2)

    @kernel_function(
        name="get_item_details",
        description="Get detailed information about a specific item including description, category, brand, and SKU",
    )
    def get_item_details(
        self, item_id: Annotated[str, "The unique identifier of the item"]
    ) -> Annotated[str, "JSON object with item details or error message"]:
        """Get detailed information for a specific item.
        
        Args:
            item_id: The unique identifier of the item to retrieve.
            
        Returns:
            str: JSON string with item details or error message if not found.
        """
        item = ITEMS.get(item_id)
        if not item:
            return json.dumps({"error": f"Item {item_id} not found"})

        return json.dumps(
            {
                "item_id": item.item_id,
                "name": item.name,
                "price": item.price,
                "description": item.description,
                "category": item.category,
                "brand": item.brand,
                "sku": item.sku,
            },
            indent=2,
        )

    @kernel_function(
        name="get_stock_info",
        description="Get stock availability information for a specific item including quantity and warehouse location",
    )
    def get_stock_info(
        self, item_id: Annotated[str, "The unique identifier of the item"]
    ) -> Annotated[str, "JSON object with stock information or error message"]:
        """Get stock information for a specific item.
        
        Args:
            item_id: The unique identifier of the item to check stock for.
            
        Returns:
            str: JSON string with stock information or error message if not found.
        """
        stock = STOCK.get(item_id)
        if not stock:
            return json.dumps({"error": f"Stock information for {item_id} not found"})

        return json.dumps(
            {
                "item_id": stock.item_id,
                "in_stock": stock.in_stock,
                "quantity": stock.quantity,
                "warehouse": stock.warehouse,
                "last_updated": stock.last_updated,
            },
            indent=2,
        )

    @kernel_function(
        name="get_tracking_status",
        description="Get tracking status and history for a shipment using the tracking number",
    )
    def get_tracking_status(
        self,
        tracking_no: Annotated[str, "The tracking number for the shipment"],
    ) -> Annotated[str, "JSON object with tracking information or error message"]:
        """Get tracking information for a shipment.
        
        Args:
            tracking_no: The tracking number to look up.
            
        Returns:
            str: JSON string with tracking information including status, location, 
                and history, or error message if not found.
        """
        tracking = TRACKING.get(tracking_no)
        if not tracking:
            return json.dumps(
                {"error": f"Tracking number {tracking_no} not found"}
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

        return json.dumps(
            {
                "tracking_no": tracking.tracking_no,
                "status": tracking.status,
                "current_location": tracking.current_location,
                "estimated_delivery": tracking.estimated_delivery,
                "delivery_date": tracking.delivery_date,
                "history": history,
            },
            indent=2,
        )

    @kernel_function(
        name="search_items_by_name",
        description="Search for items by name (case-insensitive partial match)",
    )
    def search_items_by_name(
        self, search_term: Annotated[str, "The search term to match against item names"]
    ) -> Annotated[str, "JSON array of matching items"]:
        """Search for items by name.
        
        Args:
            search_term: The search term to match against item names (case-insensitive).
            
        Returns:
            str: JSON string containing array of matching items with id, name, and price.
        """
        search_term_lower = search_term.lower()
        matching_items = [
            {"item_id": item.item_id, "name": item.name, "price": item.price}
            for item in ITEMS.values()
            if search_term_lower in item.name.lower()
        ]
        return json.dumps(matching_items, indent=2)
