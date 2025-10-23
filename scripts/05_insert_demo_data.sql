-- Script to insert demo data for items, stock, and tracking tables
-- This script creates comprehensive demo data for the AI Hackathon 2025
-- Prerequisites: Run scripts 01-04 first to create database and tables

-- Connect to the database
\c "ai-demo"

-- Disable triggers temporarily for faster bulk insert
ALTER TABLE items DISABLE TRIGGER items_update_timestamp;
ALTER TABLE stock DISABLE TRIGGER stock_update_timestamp;
ALTER TABLE stock DISABLE TRIGGER stock_update_last_updated;
ALTER TABLE tracking DISABLE TRIGGER tracking_update_timestamp;

-- ============================================================================
-- INSERT ITEMS (1000+ items across different categories)
-- ============================================================================

-- Category: Apparel - T-Shirts (200 items)
INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES
('item-001', 'Classic Cotton T-Shirt White', 29.99, 'A comfortable cotton t-shirt perfect for everyday wear. Made from 100% organic cotton with a relaxed fit. Available in white.', 'Apparel', 'BESTSELLER', 'BST-TS-001'),
('item-002', 'Classic Cotton T-Shirt Black', 29.99, 'A comfortable cotton t-shirt perfect for everyday wear. Made from 100% organic cotton with a relaxed fit. Available in black.', 'Apparel', 'BESTSELLER', 'BST-TS-002'),
('item-003', 'Classic Cotton T-Shirt Navy', 29.99, 'A comfortable cotton t-shirt perfect for everyday wear. Made from 100% organic cotton with a relaxed fit. Available in navy.', 'Apparel', 'BESTSELLER', 'BST-TS-003'),
('item-004', 'Classic Cotton T-Shirt Grey', 29.99, 'A comfortable cotton t-shirt perfect for everyday wear. Made from 100% organic cotton with a relaxed fit. Available in grey.', 'Apparel', 'BESTSELLER', 'BST-TS-004'),
('item-005', 'Premium V-Neck T-Shirt White', 34.99, 'Premium quality v-neck t-shirt with soft fabric and modern cut. Perfect for layering or wearing alone.', 'Apparel', 'VERO MODA', 'VM-VN-001'),
('item-006', 'Premium V-Neck T-Shirt Black', 34.99, 'Premium quality v-neck t-shirt with soft fabric and modern cut. Perfect for layering or wearing alone.', 'Apparel', 'VERO MODA', 'VM-VN-002'),
('item-007', 'Striped Long Sleeve T-Shirt', 39.99, 'Trendy striped long sleeve t-shirt for casual wear. Made from breathable cotton blend.', 'Apparel', 'JACK & JONES', 'JJ-LS-001'),
('item-008', 'Graphic Print T-Shirt Vintage', 32.99, 'Retro graphic print t-shirt with vintage design. 100% cotton, regular fit.', 'Apparel', 'ONLY', 'ON-GP-001'),
('item-009', 'Polo T-Shirt Classic Navy', 44.99, 'Classic polo t-shirt with button collar. Perfect for smart casual occasions.', 'Apparel', 'SELECTED', 'SEL-PL-001'),
('item-010', 'Polo T-Shirt Classic White', 44.99, 'Classic polo t-shirt with button collar. Perfect for smart casual occasions.', 'Apparel', 'SELECTED', 'SEL-PL-002');

-- Generate more T-Shirts (190 more items)
DO $$
DECLARE
    i INT;
    colors TEXT[] := ARRAY['Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Pink', 'Brown', 'Beige', 'Teal'];
    styles TEXT[] := ARRAY['Crew Neck', 'Henley', 'Raglan', 'Pocket', 'Oversized', 'Slim Fit', 'Athletic', 'Vintage Wash'];
    brands TEXT[] := ARRAY['BESTSELLER', 'VERO MODA', 'JACK & JONES', 'ONLY', 'SELECTED', 'VILA'];
BEGIN
    FOR i IN 11..200 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 3, '0'),
            styles[(i % 8) + 1] || ' T-Shirt ' || colors[(i % 10) + 1],
            ROUND((25 + (i % 30))::NUMERIC, 2),
            'High-quality ' || styles[(i % 8) + 1] || ' t-shirt in ' || colors[(i % 10) + 1] || '. Made from premium cotton blend for comfort and durability.',
            'Apparel',
            brands[(i % 6) + 1],
            'TS-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Apparel - Jeans (150 items)
DO $$
DECLARE
    i INT;
    fits TEXT[] := ARRAY['Skinny', 'Slim', 'Regular', 'Relaxed', 'Bootcut', 'Straight'];
    washes TEXT[] := ARRAY['Light Wash', 'Dark Wash', 'Medium Wash', 'Black', 'Grey', 'Distressed'];
    brands TEXT[] := ARRAY['JACK & JONES', 'VERO MODA', 'ONLY', 'SELECTED'];
BEGIN
    FOR i IN 201..350 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 3, '0'),
            fits[(i % 6) + 1] || ' Fit Jeans ' || washes[(i % 6) + 1],
            ROUND((59 + (i % 40))::NUMERIC, 2),
            'Premium quality ' || fits[(i % 6) + 1] || ' fit jeans in ' || washes[(i % 6) + 1] || '. Crafted from durable denim with stretch for comfort.',
            'Apparel',
            brands[(i % 4) + 1],
            'JNS-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Apparel - Jackets (100 items)
DO $$
DECLARE
    i INT;
    types TEXT[] := ARRAY['Denim', 'Leather', 'Bomber', 'Parka', 'Windbreaker', 'Blazer'];
    colors TEXT[] := ARRAY['Black', 'Navy', 'Brown', 'Grey', 'Green', 'Khaki'];
    brands TEXT[] := ARRAY['BESTSELLER', 'JACK & JONES', 'VERO MODA', 'SELECTED'];
BEGIN
    FOR i IN 351..450 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 3, '0'),
            types[(i % 6) + 1] || ' Jacket ' || colors[(i % 6) + 1],
            ROUND((89 + (i % 110))::NUMERIC, 2),
            'Stylish ' || types[(i % 6) + 1] || ' jacket in ' || colors[(i % 6) + 1] || '. Features modern design with quality construction for long-lasting wear.',
            'Apparel',
            brands[(i % 4) + 1],
            'JKT-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Apparel - Dresses (100 items)
DO $$
DECLARE
    i INT;
    styles TEXT[] := ARRAY['Maxi', 'Mini', 'Midi', 'Wrap', 'Shift', 'A-Line'];
    colors TEXT[] := ARRAY['Floral', 'Black', 'Red', 'Blue', 'White', 'Striped', 'Polka Dot'];
    brands TEXT[] := ARRAY['VERO MODA', 'ONLY', 'VILA'];
BEGIN
    FOR i IN 451..550 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 3, '0'),
            styles[(i % 6) + 1] || ' Dress ' || colors[(i % 7) + 1],
            ROUND((49 + (i % 60))::NUMERIC, 2),
            'Elegant ' || styles[(i % 6) + 1] || ' dress with ' || colors[(i % 7) + 1] || ' pattern. Perfect for any occasion with comfortable fit and stylish design.',
            'Apparel',
            brands[(i % 3) + 1],
            'DRS-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Footwear - Sneakers (120 items)
DO $$
DECLARE
    i INT;
    styles TEXT[] := ARRAY['Running', 'Casual', 'High-Top', 'Low-Top', 'Slip-On', 'Platform'];
    colors TEXT[] := ARRAY['White', 'Black', 'Navy', 'Grey', 'Red', 'Multi-Color'];
    brands TEXT[] := ARRAY['BESTSELLER', 'JACK & JONES', 'VERO MODA'];
BEGIN
    FOR i IN 551..670 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 3, '0'),
            styles[(i % 6) + 1] || ' Sneakers ' || colors[(i % 6) + 1],
            ROUND((69 + (i % 80))::NUMERIC, 2),
            'Comfortable ' || styles[(i % 6) + 1] || ' sneakers in ' || colors[(i % 6) + 1] || '. Featuring cushioned sole and breathable material for all-day wear.',
            'Footwear',
            brands[(i % 3) + 1],
            'SNK-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Footwear - Boots (80 items)
DO $$
DECLARE
    i INT;
    types TEXT[] := ARRAY['Ankle', 'Chelsea', 'Combat', 'Desert', 'Hiking'];
    colors TEXT[] := ARRAY['Black', 'Brown', 'Tan', 'Grey'];
    brands TEXT[] := ARRAY['SELECTED', 'JACK & JONES'];
BEGIN
    FOR i IN 671..750 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 3, '0'),
            types[(i % 5) + 1] || ' Boots ' || colors[(i % 4) + 1],
            ROUND((99 + (i % 100))::NUMERIC, 2),
            'Durable ' || types[(i % 5) + 1] || ' boots in ' || colors[(i % 4) + 1] || '. Built with quality materials for comfort and longevity.',
            'Footwear',
            brands[(i % 2) + 1],
            'BTS-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Accessories - Bags (80 items)
DO $$
DECLARE
    i INT;
    types TEXT[] := ARRAY['Backpack', 'Tote', 'Crossbody', 'Messenger', 'Clutch'];
    colors TEXT[] := ARRAY['Black', 'Brown', 'Navy', 'Grey', 'Tan'];
    brands TEXT[] := ARRAY['VERO MODA', 'ONLY', 'SELECTED'];
BEGIN
    FOR i IN 751..830 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 3, '0'),
            types[(i % 5) + 1] || ' Bag ' || colors[(i % 5) + 1],
            ROUND((39 + (i % 110))::NUMERIC, 2),
            'Stylish ' || types[(i % 5) + 1] || ' bag in ' || colors[(i % 5) + 1] || '. Features multiple compartments and quality construction.',
            'Accessories',
            brands[(i % 3) + 1],
            'BAG-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Accessories - Belts (50 items)
DO $$
DECLARE
    i INT;
    styles TEXT[] := ARRAY['Leather', 'Canvas', 'Woven', 'Chain'];
    colors TEXT[] := ARRAY['Black', 'Brown', 'Tan', 'Navy'];
    brands TEXT[] := ARRAY['JACK & JONES', 'SELECTED'];
BEGIN
    FOR i IN 831..880 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 3, '0'),
            styles[(i % 4) + 1] || ' Belt ' || colors[(i % 4) + 1],
            ROUND((19 + (i % 30))::NUMERIC, 2),
            'Quality ' || styles[(i % 4) + 1] || ' belt in ' || colors[(i % 4) + 1] || '. Classic design with durable buckle.',
            'Accessories',
            brands[(i % 2) + 1],
            'BLT-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Accessories - Watches (60 items)
DO $$
DECLARE
    i INT;
    styles TEXT[] := ARRAY['Analog', 'Digital', 'Chronograph', 'Smart'];
    colors TEXT[] := ARRAY['Silver', 'Gold', 'Black', 'Rose Gold'];
    brands TEXT[] := ARRAY['SELECTED', 'BESTSELLER'];
BEGIN
    FOR i IN 881..940 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 3, '0'),
            styles[(i % 4) + 1] || ' Watch ' || colors[(i % 4) + 1],
            ROUND((79 + (i % 120))::NUMERIC, 2),
            'Elegant ' || styles[(i % 4) + 1] || ' watch with ' || colors[(i % 4) + 1] || ' finish. Features precise movement and water resistance.',
            'Accessories',
            brands[(i % 2) + 1],
            'WCH-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Accessories - Sunglasses (60 items)
DO $$
DECLARE
    i INT;
    styles TEXT[] := ARRAY['Aviator', 'Wayfarer', 'Round', 'Cat Eye', 'Sport'];
    colors TEXT[] := ARRAY['Black', 'Brown', 'Silver', 'Gold'];
    brands TEXT[] := ARRAY['VERO MODA', 'ONLY', 'SELECTED'];
BEGIN
    FOR i IN 941..1000 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 4, '0'),
            styles[(i % 5) + 1] || ' Sunglasses ' || colors[(i % 4) + 1],
            ROUND((29 + (i % 70))::NUMERIC, 2),
            'Stylish ' || styles[(i % 5) + 1] || ' sunglasses in ' || colors[(i % 4) + 1] || '. UV protection with scratch-resistant lenses.',
            'Accessories',
            brands[(i % 3) + 1],
            'SNG-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- Category: Home & Living - Bedding (50 items)
DO $$
DECLARE
    i INT;
    types TEXT[] := ARRAY['Duvet Cover', 'Bed Sheet', 'Pillow Case', 'Comforter'];
    colors TEXT[] := ARRAY['White', 'Grey', 'Blue', 'Beige', 'Navy'];
    brands TEXT[] := ARRAY['BESTSELLER', 'VERO MODA'];
BEGIN
    FOR i IN 1001..1050 LOOP
        INSERT INTO items (item_id, name, price, description, category, brand, sku) VALUES (
            'item-' || LPAD(i::TEXT, 4, '0'),
            types[(i % 4) + 1] || ' ' || colors[(i % 5) + 1],
            ROUND((34 + (i % 60))::NUMERIC, 2),
            'Premium quality ' || types[(i % 4) + 1] || ' in ' || colors[(i % 5) + 1] || '. Made from soft, breathable fabric for comfortable sleep.',
            'Home & Living',
            brands[(i % 2) + 1],
            'BED-' || LPAD(i::TEXT, 4, '0')
        );
    END LOOP;
END $$;

-- ============================================================================
-- INSERT STOCK RECORDS
-- Creating stock for all items with varying quantities and warehouses
-- ============================================================================

-- Stock for first 500 items - Main Warehouse (mix of in-stock and out-of-stock)
INSERT INTO stock (item_id, in_stock, quantity, warehouse, last_updated)
SELECT 
    'item-' || LPAD(i::TEXT, 3, '0'),
    CASE WHEN i % 5 = 0 THEN false ELSE true END,  -- 20% out of stock
    CASE WHEN i % 5 = 0 THEN 0 ELSE (10 + (i % 90)) END,  -- 0 or 10-99
    'Main Warehouse - Copenhagen',
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (i % 30))
FROM generate_series(1, 500) i;

-- Stock for next 300 items - Regional Warehouse (different distribution)
INSERT INTO stock (item_id, in_stock, quantity, warehouse, last_updated)
SELECT 
    'item-' || LPAD(i::TEXT, 3, '0'),
    CASE WHEN i % 7 = 0 THEN false ELSE true END,  -- ~14% out of stock
    CASE WHEN i % 7 = 0 THEN 0 ELSE (5 + (i % 50)) END,
    'Regional Warehouse - Stockholm',
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (i % 20))
FROM generate_series(501, 800) i;

-- Stock for remaining items - Distribution Center (higher volume)
INSERT INTO stock (item_id, in_stock, quantity, warehouse, last_updated)
SELECT 
    'item-' || LPAD(i::TEXT, 4, '0'),
    CASE WHEN i % 10 = 0 THEN false ELSE true END,  -- 10% out of stock
    CASE WHEN i % 10 = 0 THEN 0 ELSE (20 + (i % 180)) END,
    'Distribution Center - Hamburg',
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (i % 15))
FROM generate_series(1001, 1050) i;

-- Add secondary stock location for some popular items
INSERT INTO stock (item_id, in_stock, quantity, warehouse, last_updated)
SELECT 
    'item-' || LPAD(i::TEXT, 3, '0'),
    true,
    (30 + (i % 70)),
    'Online Fulfillment Center - Amsterdam',
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (i % 10))
FROM generate_series(1, 200) i
WHERE i % 3 = 0;  -- About 67 items with dual warehouse stock

-- ============================================================================
-- INSERT TRACKING RECORDS
-- Creating tracking records in various states with realistic progression
-- ============================================================================

-- Status distribution:
-- Picked Up: 15%, Processed: 10%, In Transit: 25%, Out for Delivery: 20%, 
-- Delivered: 25%, Returned: 3%, Failed: 2%

-- Delivered shipments (tracking-0001 to tracking-0250)
INSERT INTO tracking (tracking_no, status, current_location, estimated_delivery, delivery_date, created_at)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    'Delivered',
    CASE (i % 10)
        WHEN 0 THEN 'Customer Address - Copenhagen'
        WHEN 1 THEN 'Customer Address - Stockholm'
        WHEN 2 THEN 'Customer Address - Oslo'
        WHEN 3 THEN 'Customer Address - Helsinki'
        WHEN 4 THEN 'Customer Address - Amsterdam'
        WHEN 5 THEN 'Customer Address - Berlin'
        WHEN 6 THEN 'Customer Address - Hamburg'
        WHEN 7 THEN 'Customer Address - Malmö'
        WHEN 8 THEN 'Customer Address - Gothenburg'
        ELSE 'Customer Address - Aarhus'
    END,
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (5 + (i % 10))),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (i % 7)),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (7 + (i % 15)))
FROM generate_series(1, 250) i;

-- Out for Delivery shipments (tracking-0251 to tracking-0450)
INSERT INTO tracking (tracking_no, status, current_location, estimated_delivery, created_at)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    'Out for Delivery',
    CASE (i % 8)
        WHEN 0 THEN 'Local Delivery Hub - Copenhagen North'
        WHEN 1 THEN 'Local Delivery Hub - Stockholm Central'
        WHEN 2 THEN 'Local Delivery Hub - Oslo West'
        WHEN 3 THEN 'Local Delivery Hub - Helsinki East'
        WHEN 4 THEN 'Local Delivery Hub - Amsterdam South'
        WHEN 5 THEN 'Local Delivery Hub - Berlin Central'
        WHEN 6 THEN 'Local Delivery Hub - Hamburg Port'
        ELSE 'Local Delivery Hub - Malmö Center'
    END,
    CURRENT_TIMESTAMP + (INTERVAL '1 hour' * (2 + (i % 8))),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (2 + (i % 5)))
FROM generate_series(251, 450) i;

-- In Transit shipments (tracking-0451 to tracking-0700)
INSERT INTO tracking (tracking_no, status, current_location, estimated_delivery, created_at)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    'In Transit',
    CASE (i % 12)
        WHEN 0 THEN 'Sorting Facility - Copenhagen'
        WHEN 1 THEN 'Sorting Facility - Stockholm'
        WHEN 2 THEN 'Sorting Facility - Oslo'
        WHEN 3 THEN 'Sorting Facility - Helsinki'
        WHEN 4 THEN 'Sorting Facility - Amsterdam'
        WHEN 5 THEN 'Sorting Facility - Berlin'
        WHEN 6 THEN 'In Transit - Highway E20'
        WHEN 7 THEN 'In Transit - Highway E4'
        WHEN 8 THEN 'In Transit - Highway E18'
        WHEN 9 THEN 'Distribution Hub - Malmö'
        WHEN 10 THEN 'Distribution Hub - Gothenburg'
        ELSE 'Cross-dock Facility - Aarhus'
    END,
    CURRENT_TIMESTAMP + (INTERVAL '1 day' * (1 + (i % 4))),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (3 + (i % 6)))
FROM generate_series(451, 700) i;

-- Processed shipments (tracking-0701 to tracking-0800)
INSERT INTO tracking (tracking_no, status, current_location, estimated_delivery, created_at)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    'Processed',
    CASE (i % 5)
        WHEN 0 THEN 'Processing Center - Copenhagen'
        WHEN 1 THEN 'Processing Center - Stockholm'
        WHEN 2 THEN 'Processing Center - Hamburg'
        WHEN 3 THEN 'Processing Center - Amsterdam'
        ELSE 'Processing Center - Berlin'
    END,
    CURRENT_TIMESTAMP + (INTERVAL '1 day' * (2 + (i % 5))),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (4 + (i % 7)))
FROM generate_series(701, 800) i;

-- Picked Up shipments (tracking-0801 to tracking-0950)
INSERT INTO tracking (tracking_no, status, current_location, estimated_delivery, created_at)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    'Picked Up',
    CASE (i % 6)
        WHEN 0 THEN 'Main Warehouse - Copenhagen'
        WHEN 1 THEN 'Regional Warehouse - Stockholm'
        WHEN 2 THEN 'Distribution Center - Hamburg'
        WHEN 3 THEN 'Online Fulfillment Center - Amsterdam'
        WHEN 4 THEN 'Warehouse - Oslo'
        ELSE 'Warehouse - Berlin'
    END,
    CURRENT_TIMESTAMP + (INTERVAL '1 day' * (3 + (i % 6))),
    CURRENT_TIMESTAMP - (INTERVAL '1 hour' * (2 + (i % 20)))
FROM generate_series(801, 950) i;

-- Returned shipments (tracking-0951 to tracking-0980)
INSERT INTO tracking (tracking_no, status, current_location, estimated_delivery, created_at)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    'Returned',
    CASE (i % 4)
        WHEN 0 THEN 'Returns Processing - Copenhagen'
        WHEN 1 THEN 'Returns Processing - Stockholm'
        WHEN 2 THEN 'Returns Processing - Hamburg'
        ELSE 'Returns Processing - Amsterdam'
    END,
    NULL,
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (10 + (i % 15)))
FROM generate_series(951, 980) i;

-- Failed shipments (tracking-0981 to tracking-1000)
INSERT INTO tracking (tracking_no, status, current_location, estimated_delivery, created_at)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    'Failed',
    CASE (i % 5)
        WHEN 0 THEN 'Failed Delivery Hub - Copenhagen'
        WHEN 1 THEN 'Failed Delivery Hub - Stockholm'
        WHEN 2 THEN 'Failed Delivery Hub - Oslo'
        WHEN 3 THEN 'Failed Delivery Hub - Amsterdam'
        ELSE 'Failed Delivery Hub - Berlin'
    END,
    NULL,
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (8 + (i % 12)))
FROM generate_series(981, 1000) i;

-- ============================================================================
-- INSERT TRACKING EVENTS
-- Creating historical event data for each tracking record
-- ============================================================================

-- Events for Delivered shipments (complete journey)
INSERT INTO tracking_events (tracking_no, timestamp, location, status, description)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (7 + (i % 15))),
    CASE (i % 4) WHEN 0 THEN 'Main Warehouse - Copenhagen' WHEN 1 THEN 'Regional Warehouse - Stockholm' WHEN 2 THEN 'Distribution Center - Hamburg' ELSE 'Online Fulfillment Center - Amsterdam' END,
    'Picked Up',
    'Package picked up from warehouse and ready for processing.'
FROM generate_series(1, 250) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (6 + (i % 15))),
    CASE (i % 4) WHEN 0 THEN 'Processing Center - Copenhagen' WHEN 1 THEN 'Processing Center - Stockholm' WHEN 2 THEN 'Processing Center - Hamburg' ELSE 'Processing Center - Amsterdam' END,
    'Processed',
    'Package processed and sorted for shipment.'
FROM generate_series(1, 250) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (4 + (i % 10))),
    CASE (i % 6) WHEN 0 THEN 'Sorting Facility - Copenhagen' WHEN 1 THEN 'Sorting Facility - Stockholm' WHEN 2 THEN 'Sorting Facility - Oslo' WHEN 3 THEN 'In Transit - Highway E20' WHEN 4 THEN 'Distribution Hub - Malmö' ELSE 'Distribution Hub - Gothenburg' END,
    'In Transit',
    'Package in transit to destination.'
FROM generate_series(1, 250) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (1 + (i % 7))),
    CASE (i % 5) WHEN 0 THEN 'Local Delivery Hub - Copenhagen North' WHEN 1 THEN 'Local Delivery Hub - Stockholm Central' WHEN 2 THEN 'Local Delivery Hub - Oslo West' WHEN 3 THEN 'Local Delivery Hub - Helsinki East' ELSE 'Local Delivery Hub - Amsterdam South' END,
    'Out for Delivery',
    'Package out for delivery to customer address.'
FROM generate_series(1, 250) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (i % 7)),
    CASE (i % 10) WHEN 0 THEN 'Customer Address - Copenhagen' WHEN 1 THEN 'Customer Address - Stockholm' WHEN 2 THEN 'Customer Address - Oslo' WHEN 3 THEN 'Customer Address - Helsinki' WHEN 4 THEN 'Customer Address - Amsterdam' WHEN 5 THEN 'Customer Address - Berlin' WHEN 6 THEN 'Customer Address - Hamburg' WHEN 7 THEN 'Customer Address - Malmö' WHEN 8 THEN 'Customer Address - Gothenburg' ELSE 'Customer Address - Aarhus' END,
    'Delivered',
    'Package successfully delivered to customer.'
FROM generate_series(1, 250) i;

-- Events for Out for Delivery shipments
INSERT INTO tracking_events (tracking_no, timestamp, location, status, description)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (2 + (i % 5))),
    CASE (i % 3) WHEN 0 THEN 'Main Warehouse - Copenhagen' WHEN 1 THEN 'Regional Warehouse - Stockholm' ELSE 'Distribution Center - Hamburg' END,
    'Picked Up',
    'Package picked up from warehouse.'
FROM generate_series(251, 450) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (1.5 + (i % 5))),
    CASE (i % 3) WHEN 0 THEN 'Processing Center - Copenhagen' WHEN 1 THEN 'Processing Center - Stockholm' ELSE 'Processing Center - Hamburg' END,
    'Processed',
    'Package processed and sorted.'
FROM generate_series(251, 450) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (1 + (i % 4))),
    CASE (i % 4) WHEN 0 THEN 'Sorting Facility - Copenhagen' WHEN 1 THEN 'Distribution Hub - Malmö' WHEN 2 THEN 'In Transit - Highway E20' ELSE 'Sorting Facility - Stockholm' END,
    'In Transit',
    'Package in transit to local delivery hub.'
FROM generate_series(251, 450) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 hour' * (4 + (i % 10))),
    CASE (i % 8) WHEN 0 THEN 'Local Delivery Hub - Copenhagen North' WHEN 1 THEN 'Local Delivery Hub - Stockholm Central' WHEN 2 THEN 'Local Delivery Hub - Oslo West' WHEN 3 THEN 'Local Delivery Hub - Helsinki East' WHEN 4 THEN 'Local Delivery Hub - Amsterdam South' WHEN 5 THEN 'Local Delivery Hub - Berlin Central' WHEN 6 THEN 'Local Delivery Hub - Hamburg Port' ELSE 'Local Delivery Hub - Malmö Center' END,
    'Out for Delivery',
    'Package loaded on delivery vehicle and out for delivery.'
FROM generate_series(251, 450) i;

-- Events for In Transit shipments
INSERT INTO tracking_events (tracking_no, timestamp, location, status, description)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (3 + (i % 6))),
    CASE (i % 4) WHEN 0 THEN 'Main Warehouse - Copenhagen' WHEN 1 THEN 'Regional Warehouse - Stockholm' WHEN 2 THEN 'Distribution Center - Hamburg' ELSE 'Online Fulfillment Center - Amsterdam' END,
    'Picked Up',
    'Package picked up from warehouse.'
FROM generate_series(451, 700) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (2 + (i % 5))),
    CASE (i % 4) WHEN 0 THEN 'Processing Center - Copenhagen' WHEN 1 THEN 'Processing Center - Stockholm' WHEN 2 THEN 'Processing Center - Hamburg' ELSE 'Processing Center - Amsterdam' END,
    'Processed',
    'Package processed and sorted for shipment.'
FROM generate_series(451, 700) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (0.5 + (i % 3))),
    CASE (i % 12) WHEN 0 THEN 'Sorting Facility - Copenhagen' WHEN 1 THEN 'Sorting Facility - Stockholm' WHEN 2 THEN 'Sorting Facility - Oslo' WHEN 3 THEN 'Sorting Facility - Helsinki' WHEN 4 THEN 'Sorting Facility - Amsterdam' WHEN 5 THEN 'Sorting Facility - Berlin' WHEN 6 THEN 'In Transit - Highway E20' WHEN 7 THEN 'In Transit - Highway E4' WHEN 8 THEN 'In Transit - Highway E18' WHEN 9 THEN 'Distribution Hub - Malmö' WHEN 10 THEN 'Distribution Hub - Gothenburg' ELSE 'Cross-dock Facility - Aarhus' END,
    'In Transit',
    'Package currently in transit to destination.'
FROM generate_series(451, 700) i;

-- Events for Processed shipments
INSERT INTO tracking_events (tracking_no, timestamp, location, status, description)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (4 + (i % 7))),
    CASE (i % 5) WHEN 0 THEN 'Main Warehouse - Copenhagen' WHEN 1 THEN 'Regional Warehouse - Stockholm' WHEN 2 THEN 'Distribution Center - Hamburg' WHEN 3 THEN 'Online Fulfillment Center - Amsterdam' ELSE 'Warehouse - Berlin' END,
    'Picked Up',
    'Package picked up from warehouse.'
FROM generate_series(701, 800) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 hour' * (6 + (i % 20))),
    CASE (i % 5) WHEN 0 THEN 'Processing Center - Copenhagen' WHEN 1 THEN 'Processing Center - Stockholm' WHEN 2 THEN 'Processing Center - Hamburg' WHEN 3 THEN 'Processing Center - Amsterdam' ELSE 'Processing Center - Berlin' END,
    'Processed',
    'Package processed and ready for shipment.'
FROM generate_series(701, 800) i;

-- Events for Picked Up shipments
INSERT INTO tracking_events (tracking_no, timestamp, location, status, description)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 hour' * (2 + (i % 20))),
    CASE (i % 6) WHEN 0 THEN 'Main Warehouse - Copenhagen' WHEN 1 THEN 'Regional Warehouse - Stockholm' WHEN 2 THEN 'Distribution Center - Hamburg' WHEN 3 THEN 'Online Fulfillment Center - Amsterdam' WHEN 4 THEN 'Warehouse - Oslo' ELSE 'Warehouse - Berlin' END,
    'Picked Up',
    'Package picked up and awaiting processing.'
FROM generate_series(801, 950) i;

-- Events for Returned shipments
INSERT INTO tracking_events (tracking_no, timestamp, location, status, description)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (10 + (i % 15))),
    CASE (i % 3) WHEN 0 THEN 'Main Warehouse - Copenhagen' WHEN 1 THEN 'Regional Warehouse - Stockholm' ELSE 'Distribution Center - Hamburg' END,
    'Picked Up',
    'Package picked up from warehouse.'
FROM generate_series(951, 980) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (9 + (i % 15))),
    CASE (i % 3) WHEN 0 THEN 'Processing Center - Copenhagen' WHEN 1 THEN 'Processing Center - Stockholm' ELSE 'Processing Center - Hamburg' END,
    'Processed',
    'Package processed for delivery.'
FROM generate_series(951, 980) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (7 + (i % 12))),
    'In Transit',
    'In Transit',
    'Package in transit to customer.'
FROM generate_series(951, 980) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (5 + (i % 10))),
    'Customer Address',
    'Delivered',
    'Package delivered to customer.'
FROM generate_series(951, 980) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (2 + (i % 8))),
    CASE (i % 4) WHEN 0 THEN 'Returns Processing - Copenhagen' WHEN 1 THEN 'Returns Processing - Stockholm' WHEN 2 THEN 'Returns Processing - Hamburg' ELSE 'Returns Processing - Amsterdam' END,
    'Returned',
    'Package returned by customer and received at returns facility.'
FROM generate_series(951, 980) i;

-- Events for Failed shipments
INSERT INTO tracking_events (tracking_no, timestamp, location, status, description)
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (8 + (i % 12))),
    CASE (i % 4) WHEN 0 THEN 'Main Warehouse - Copenhagen' WHEN 1 THEN 'Regional Warehouse - Stockholm' WHEN 2 THEN 'Distribution Center - Hamburg' ELSE 'Online Fulfillment Center - Amsterdam' END,
    'Picked Up',
    'Package picked up from warehouse.'
FROM generate_series(981, 1000) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (7 + (i % 12))),
    CASE (i % 4) WHEN 0 THEN 'Processing Center - Copenhagen' WHEN 1 THEN 'Processing Center - Stockholm' WHEN 2 THEN 'Processing Center - Hamburg' ELSE 'Processing Center - Amsterdam' END,
    'Processed',
    'Package processed for delivery.'
FROM generate_series(981, 1000) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (5 + (i % 10))),
    'In Transit',
    'In Transit',
    'Package in transit.'
FROM generate_series(981, 1000) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (2 + (i % 8))),
    'Local Delivery Hub',
    'Out for Delivery',
    'Package out for delivery.'
FROM generate_series(981, 1000) i
UNION ALL
SELECT 
    'tracking-' || LPAD(i::TEXT, 4, '0'),
    CURRENT_TIMESTAMP - (INTERVAL '1 day' * (i % 6)),
    CASE (i % 5) WHEN 0 THEN 'Failed Delivery Hub - Copenhagen' WHEN 1 THEN 'Failed Delivery Hub - Stockholm' WHEN 2 THEN 'Failed Delivery Hub - Oslo' WHEN 3 THEN 'Failed Delivery Hub - Amsterdam' ELSE 'Failed Delivery Hub - Berlin' END,
    'Failed',
    'Delivery failed - customer unavailable or incorrect address. Package held for customer pickup or return.'
FROM generate_series(981, 1000) i;

-- Re-enable triggers
ALTER TABLE items ENABLE TRIGGER items_update_timestamp;
ALTER TABLE stock ENABLE TRIGGER stock_update_timestamp;
ALTER TABLE stock ENABLE TRIGGER stock_update_last_updated;
ALTER TABLE tracking ENABLE TRIGGER tracking_update_timestamp;

-- Display summary statistics
DO $$
DECLARE
    item_count INT;
    stock_count INT;
    tracking_count INT;
    events_count INT;
    in_stock_count INT;
    out_stock_count INT;
    rec RECORD;
BEGIN
    SELECT COUNT(*) INTO item_count FROM items;
    SELECT COUNT(*) INTO stock_count FROM stock;
    SELECT COUNT(*) INTO tracking_count FROM tracking;
    SELECT COUNT(*) INTO events_count FROM tracking_events;
    SELECT COUNT(*) INTO in_stock_count FROM stock WHERE in_stock = true;
    SELECT COUNT(*) INTO out_stock_count FROM stock WHERE in_stock = false;
    
    RAISE NOTICE '====================================';
    RAISE NOTICE 'DEMO DATA INSERTION COMPLETE';
    RAISE NOTICE '====================================';
    RAISE NOTICE 'Total Items: %', item_count;
    RAISE NOTICE 'Total Stock Records: %', stock_count;
    RAISE NOTICE '  - In Stock: %', in_stock_count;
    RAISE NOTICE '  - Out of Stock: %', out_stock_count;
    RAISE NOTICE 'Total Tracking Records: %', tracking_count;
    RAISE NOTICE 'Total Tracking Events: %', events_count;
    RAISE NOTICE '====================================';
    
    -- Display tracking status breakdown
    RAISE NOTICE 'Tracking Status Breakdown:';
    FOR rec IN (
        SELECT status, COUNT(*) as count 
        FROM tracking 
        GROUP BY status 
        ORDER BY count DESC
    ) LOOP
        RAISE NOTICE '  - %: %', rec.status, rec.count;
    END LOOP;
    RAISE NOTICE '====================================';
END $$;
