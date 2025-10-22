-- Script to create the stock table
-- This table conforms to the StockInfo model from the OpenAPI specification
-- Implements best practices for PostgreSQL tables

-- Drop table if exists (uncomment if you want to recreate)
-- DROP TABLE IF EXISTS stock CASCADE;

-- Create the stock table
CREATE TABLE stock (
    -- Primary key (composite or single - using single id for flexibility)
    id SERIAL PRIMARY KEY,
    
    -- Foreign key to items table
    item_id VARCHAR(50) NOT NULL,
    
    -- Required fields from StockInfo model
    in_stock BOOLEAN NOT NULL DEFAULT false,
    quantity INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    
    -- Optional fields
    warehouse VARCHAR(255),
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Audit fields (best practice)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraint
    CONSTRAINT fk_stock_item_id 
        FOREIGN KEY (item_id) 
        REFERENCES items(item_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Ensure only one stock record per item per warehouse
    CONSTRAINT unique_item_warehouse UNIQUE (item_id, warehouse),
    
    -- Additional business logic constraint
    CONSTRAINT stock_quantity_consistency 
        CHECK (
            (in_stock = true AND quantity > 0) OR 
            (in_stock = false AND quantity = 0)
        )
);

-- Create indexes for better query performance
CREATE INDEX idx_stock_item_id ON stock(item_id);
CREATE INDEX idx_stock_warehouse ON stock(warehouse);
CREATE INDEX idx_stock_in_stock ON stock(in_stock);
CREATE INDEX idx_stock_last_updated ON stock(last_updated);

-- Add comments to document the table and columns
COMMENT ON TABLE stock IS 'Stores stock availability information for items';
COMMENT ON COLUMN stock.id IS 'Unique identifier for the stock record';
COMMENT ON COLUMN stock.item_id IS 'Reference to the item in the items table';
COMMENT ON COLUMN stock.in_stock IS 'Whether the item is currently in stock';
COMMENT ON COLUMN stock.quantity IS 'Number of units available in stock';
COMMENT ON COLUMN stock.warehouse IS 'Name or location of the warehouse';
COMMENT ON COLUMN stock.last_updated IS 'Timestamp when stock information was last updated';
COMMENT ON COLUMN stock.created_at IS 'Timestamp when the record was created';
COMMENT ON COLUMN stock.updated_at IS 'Timestamp when the record was last updated';

-- Create trigger to call the function before update
CREATE TRIGGER stock_update_timestamp
    BEFORE UPDATE ON stock
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Create trigger to automatically update last_updated
CREATE OR REPLACE FUNCTION update_stock_last_updated()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER stock_update_last_updated
    BEFORE UPDATE ON stock
    FOR EACH ROW
    EXECUTE FUNCTION update_stock_last_updated();
