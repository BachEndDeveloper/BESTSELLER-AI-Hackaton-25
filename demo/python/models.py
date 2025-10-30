"""Static data models and repository for the demo application."""

from dataclasses import dataclass
from datetime import datetime
from typing import Optional


@dataclass
class ItemSummary:
    """Summary information for an item."""

    item_id: str
    name: str
    price: float


@dataclass
class ItemDetail:
    """Detailed information for an item."""

    item_id: str
    name: str
    price: float
    description: str
    category: Optional[str] = None
    brand: Optional[str] = None
    sku: Optional[str] = None


@dataclass
class StockInfo:
    """Stock availability information."""

    item_id: str
    in_stock: bool
    quantity: int
    warehouse: Optional[str] = None
    last_updated: Optional[str] = None


@dataclass
class TrackingEvent:
    """Individual tracking event."""

    timestamp: str
    location: str
    status: str
    description: str


@dataclass
class TrackingInfo:
    """Tracking information for a shipment."""

    tracking_no: str
    status: str
    current_location: str
    estimated_delivery: Optional[str] = None
    delivery_date: Optional[str] = None
    history: list[TrackingEvent] | None = None


# Static data storage
ITEMS: dict[str, ItemDetail] = {
    "item-001": ItemDetail(
        item_id="item-001",
        name="Classic T-Shirt",
        price=29.99,
        description="A comfortable cotton t-shirt perfect for everyday wear. Made from 100% organic cotton with a relaxed fit. Available in multiple colors and sizes.",
        category="Apparel",
        brand="BESTSELLER",
        sku="BST-TS-001",
    ),
    "item-002": ItemDetail(
        item_id="item-002",
        name="Denim Jeans",
        price=79.99,
        description="Premium denim jeans with a classic straight fit. Durable construction with reinforced stitching. Perfect for casual or smart-casual occasions.",
        category="Apparel",
        brand="BESTSELLER",
        sku="BST-DJ-002",
    ),
    "item-003": ItemDetail(
        item_id="item-003",
        name="Summer Dress",
        price=49.99,
        description="Light and breezy summer dress made from breathable fabric. Features a flattering A-line cut and comes in vibrant patterns. Perfect for warm weather.",
        category="Apparel",
        brand="BESTSELLER",
        sku="BST-SD-003",
    ),
    "item-004": ItemDetail(
        item_id="item-004",
        name="Leather Jacket",
        price=199.99,
        description="Premium leather jacket with a timeless design. Genuine leather construction with soft lining. Features multiple pockets and adjustable waist.",
        category="Apparel",
        brand="BESTSELLER",
        sku="BST-LJ-004",
    ),
    "item-005": ItemDetail(
        item_id="item-005",
        name="Running Sneakers",
        price=89.99,
        description="High-performance running sneakers with cushioned sole. Breathable mesh upper and responsive cushioning. Designed for comfort during long runs.",
        category="Footwear",
        brand="BESTSELLER",
        sku="BST-RS-005",
    ),
}

STOCK: dict[str, StockInfo] = {
    "item-001": StockInfo(
        item_id="item-001",
        in_stock=True,
        quantity=150,
        warehouse="Main Warehouse - Copenhagen",
        last_updated="2025-10-30T06:00:00Z",
    ),
    "item-002": StockInfo(
        item_id="item-002",
        in_stock=False,
        quantity=0,
        warehouse="Main Warehouse - Copenhagen",
        last_updated="2025-10-30T06:00:00Z",
    ),
    "item-003": StockInfo(
        item_id="item-003",
        in_stock=True,
        quantity=75,
        warehouse="Main Warehouse - Copenhagen",
        last_updated="2025-10-30T06:00:00Z",
    ),
    "item-004": StockInfo(
        item_id="item-004",
        in_stock=True,
        quantity=25,
        warehouse="Main Warehouse - Copenhagen",
        last_updated="2025-10-30T06:00:00Z",
    ),
    "item-005": StockInfo(
        item_id="item-005",
        in_stock=True,
        quantity=200,
        warehouse="Main Warehouse - Copenhagen",
        last_updated="2025-10-30T06:00:00Z",
    ),
}

TRACKING: dict[str, TrackingInfo] = {
    "TRK-2025-001234": TrackingInfo(
        tracking_no="TRK-2025-001234",
        status="In Transit",
        current_location="Distribution Center - Copenhagen",
        estimated_delivery="2025-11-02T18:00:00Z",
        history=[
            TrackingEvent(
                timestamp="2025-10-30T08:00:00Z",
                location="Distribution Center - Copenhagen",
                status="In Transit",
                description="Package is on its way",
            ),
            TrackingEvent(
                timestamp="2025-10-29T14:30:00Z",
                location="Warehouse - Aarhus",
                status="Processed",
                description="Package processed at warehouse",
            ),
            TrackingEvent(
                timestamp="2025-10-29T10:00:00Z",
                location="Origin",
                status="Picked Up",
                description="Package picked up",
            ),
        ],
    ),
    "TRK-2025-001235": TrackingInfo(
        tracking_no="TRK-2025-001235",
        status="Delivered",
        current_location="Customer Location",
        estimated_delivery="2025-10-28T14:30:00Z",
        delivery_date="2025-10-28T14:30:00Z",
        history=[
            TrackingEvent(
                timestamp="2025-10-28T14:30:00Z",
                location="Customer Location",
                status="Delivered",
                description="Package delivered successfully",
            ),
            TrackingEvent(
                timestamp="2025-10-28T08:00:00Z",
                location="Local Delivery Hub",
                status="Out for Delivery",
                description="Package out for delivery",
            ),
        ],
    ),
    "TRK-2025-001236": TrackingInfo(
        tracking_no="TRK-2025-001236",
        status="Out for Delivery",
        current_location="Local Delivery Hub - Stockholm",
        estimated_delivery="2025-10-30T18:00:00Z",
        history=[
            TrackingEvent(
                timestamp="2025-10-30T07:00:00Z",
                location="Local Delivery Hub - Stockholm",
                status="Out for Delivery",
                description="Package is out for delivery",
            ),
        ],
    ),
}
