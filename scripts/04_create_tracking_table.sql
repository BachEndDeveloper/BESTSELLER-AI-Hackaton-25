-- Script to create the tracking tables
-- This conforms to the TrackingInfo and TrackingEvent models from the OpenAPI specification
-- Implements best practices for PostgreSQL tables

-- Drop tables if exist (uncomment if you want to recreate)
-- DROP TABLE IF EXISTS tracking_events CASCADE;
-- DROP TABLE IF EXISTS tracking CASCADE;

-- Create the main tracking table
CREATE TABLE tracking (
    -- Primary key
    tracking_no VARCHAR(50) PRIMARY KEY,
    
    -- Required fields from TrackingInfo model
    status VARCHAR(50) NOT NULL,
    current_location VARCHAR(255) NOT NULL,
    
    -- Optional fields
    estimated_delivery TIMESTAMP WITH TIME ZONE,
    delivery_date TIMESTAMP WITH TIME ZONE,
    
    -- Audit fields (best practice)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints for status enum values
    CONSTRAINT tracking_status_valid CHECK (
        status IN (
            'Picked Up',
            'Processed',
            'In Transit',
            'Out for Delivery',
            'Delivered',
            'Returned',
            'Failed'
        )
    ),
    
    -- Business logic constraint: delivery_date should only be set when status is 'Delivered'
    CONSTRAINT tracking_delivery_date_logic CHECK (
        (status = 'Delivered' AND delivery_date IS NOT NULL) OR
        (status != 'Delivered' AND delivery_date IS NULL)
    )
);

-- Create the tracking events table (history)
CREATE TABLE tracking_events (
    -- Primary key
    id SERIAL PRIMARY KEY,
    
    -- Foreign key to tracking table
    tracking_no VARCHAR(50) NOT NULL,
    
    -- Required fields from TrackingEvent model
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    location VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    
    -- Optional field
    description TEXT,
    
    -- Audit fields (best practice)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraint
    CONSTRAINT fk_tracking_events_tracking_no 
        FOREIGN KEY (tracking_no) 
        REFERENCES tracking(tracking_no) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Constraints for status enum values
    CONSTRAINT tracking_events_status_valid CHECK (
        status IN (
            'Picked Up',
            'Processed',
            'In Transit',
            'Out for Delivery',
            'Delivered',
            'Returned',
            'Failed'
        )
    )
);

-- Create indexes for better query performance
CREATE INDEX idx_tracking_status ON tracking(status);
CREATE INDEX idx_tracking_current_location ON tracking(current_location);
CREATE INDEX idx_tracking_estimated_delivery ON tracking(estimated_delivery);
CREATE INDEX idx_tracking_delivery_date ON tracking(delivery_date);

CREATE INDEX idx_tracking_events_tracking_no ON tracking_events(tracking_no);
CREATE INDEX idx_tracking_events_timestamp ON tracking_events(timestamp);
CREATE INDEX idx_tracking_events_status ON tracking_events(status);

-- Add comments to document the tables and columns
COMMENT ON TABLE tracking IS 'Stores tracking information for shipments';
COMMENT ON COLUMN tracking.tracking_no IS 'Unique tracking number for the shipment';
COMMENT ON COLUMN tracking.status IS 'Current status of the shipment';
COMMENT ON COLUMN tracking.current_location IS 'Current location of the package';
COMMENT ON COLUMN tracking.estimated_delivery IS 'Estimated delivery date and time';
COMMENT ON COLUMN tracking.delivery_date IS 'Actual delivery date and time (only present when delivered)';
COMMENT ON COLUMN tracking.created_at IS 'Timestamp when the tracking record was created';
COMMENT ON COLUMN tracking.updated_at IS 'Timestamp when the tracking record was last updated';

COMMENT ON TABLE tracking_events IS 'Stores historical tracking events for shipments';
COMMENT ON COLUMN tracking_events.id IS 'Unique identifier for the tracking event';
COMMENT ON COLUMN tracking_events.tracking_no IS 'Reference to the tracking number';
COMMENT ON COLUMN tracking_events.timestamp IS 'Timestamp of the tracking event';
COMMENT ON COLUMN tracking_events.location IS 'Location where the event occurred';
COMMENT ON COLUMN tracking_events.status IS 'Status at this point in time';
COMMENT ON COLUMN tracking_events.description IS 'Detailed description of the event';
COMMENT ON COLUMN tracking_events.created_at IS 'Timestamp when the event record was created';

-- Create trigger to call the function before update
CREATE TRIGGER tracking_update_timestamp
    BEFORE UPDATE ON tracking
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
