-- Script to create the items table
-- This table conforms to the ItemDetail model from the OpenAPI specification
-- Implements best practices for PostgreSQL tables

-- Drop table if exists (uncomment if you want to recreate)
-- DROP TABLE IF EXISTS items CASCADE;

-- Create the items table
CREATE TABLE items (
    -- Primary key
    item_id VARCHAR(50) PRIMARY KEY,
    
    -- Required fields
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    description TEXT NOT NULL,
    
    -- Optional fields
    category VARCHAR(100),
    brand VARCHAR(100),
    sku VARCHAR(50) UNIQUE,
    
    -- Audit fields (best practice)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Additional constraints
    CONSTRAINT items_name_not_empty CHECK (LENGTH(TRIM(name)) > 0),
    CONSTRAINT items_description_not_empty CHECK (LENGTH(TRIM(description)) > 0)
);

-- Create indexes for better query performance
CREATE INDEX idx_items_category ON items(category);
CREATE INDEX idx_items_brand ON items(brand);
CREATE INDEX idx_items_sku ON items(sku);
CREATE INDEX idx_items_price ON items(price);
CREATE INDEX idx_items_name ON items(name);

-- Add comments to document the table and columns
COMMENT ON TABLE items IS 'Stores product/item information for the BESTSELLER catalog';
COMMENT ON COLUMN items.item_id IS 'Unique identifier for the item (e.g., item-001)';
COMMENT ON COLUMN items.name IS 'Name of the item';
COMMENT ON COLUMN items.price IS 'Price of the item in the default currency';
COMMENT ON COLUMN items.description IS 'Full description of the item';
COMMENT ON COLUMN items.category IS 'Category of the item (e.g., Apparel)';
COMMENT ON COLUMN items.brand IS 'Brand name';
COMMENT ON COLUMN items.sku IS 'Stock Keeping Unit identifier';
COMMENT ON COLUMN items.created_at IS 'Timestamp when the record was created';
COMMENT ON COLUMN items.updated_at IS 'Timestamp when the record was last updated';

-- Create trigger function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to call the function before update
CREATE TRIGGER items_update_timestamp
    BEFORE UPDATE ON items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
