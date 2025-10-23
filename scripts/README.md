# PostgreSQL Database Scripts

This folder contains SQL scripts for setting up the BESTSELLER AI Hackathon 2025 demo database.

## Overview

The scripts create a PostgreSQL database named `ai-demo` with three main tables that conform to the OpenAPI specification models:

1. **items** - Product/item catalog
2. **stock** - Stock availability information
3. **tracking** - Shipment tracking information

## Scripts

### 01_create_database.sql
Creates the PostgreSQL database named `ai-demo` with UTF-8 encoding.

### 02_create_items_table.sql
Creates the `items` table conforming to the `ItemDetail` model from the OpenAPI specification.

**Features:**
- Primary key on `item_id`
- Required fields: `item_id`, `name`, `price`, `description`
- Optional fields: `category`, `brand`, `sku`
- Audit fields: `created_at`, `updated_at`
- Indexes on commonly queried fields
- Automatic `updated_at` timestamp trigger
- Check constraints for data validation

### 03_create_stock_table.sql
Creates the `stock` table conforming to the `StockInfo` model from the OpenAPI specification.

**Features:**
- Foreign key relationship to `items` table
- Required fields: `item_id`, `in_stock`, `quantity`
- Optional fields: `warehouse`, `last_updated`
- Audit fields: `created_at`, `updated_at`
- Unique constraint on `item_id` + `warehouse`
- Business logic constraints (e.g., quantity consistency)
- Automatic timestamp updates

### 04_create_tracking_table.sql
Creates the `tracking` and `tracking_events` tables conforming to the `TrackingInfo` and `TrackingEvent` models from the OpenAPI specification.

**Features:**
- Main `tracking` table for current tracking status
- `tracking_events` table for historical tracking events
- Foreign key relationship between tables
- Status enum constraints
- Business logic constraints
- Comprehensive indexing
- Automatic timestamp updates

## How to Use

### Prerequisites
- PostgreSQL 12 or higher installed
- PostgreSQL client (`psql`) available

### Execution Order

Execute the scripts in the following order:

```bash
# 1. Create the database
psql -U postgres -f 01_create_database.sql

# 2. Create the items table
psql -U postgres -d ai-demo -f 02_create_items_table.sql

# 3. Create the stock table
psql -U postgres -d ai-demo -f 03_create_stock_table.sql

# 4. Create the tracking tables
psql -U postgres -d ai-demo -f 04_create_tracking_table.sql
```

### Alternative: Run all scripts at once

```bash
# Run all scripts in sequence
for script in 01_create_database.sql 02_create_items_table.sql 03_create_stock_table.sql 04_create_tracking_table.sql; do
    if [[ "$script" == "01_create_database.sql" ]]; then
        psql -U postgres -f "$script"
    else
        psql -U postgres -d ai-demo -f "$script"
    fi
done
```

## Best Practices Implemented

1. **Primary Keys**: All tables have appropriate primary keys
2. **Foreign Keys**: Relationships between tables are enforced with foreign key constraints
3. **Indexes**: Indexes on commonly queried columns for better performance
4. **Constraints**: Check constraints to enforce business rules and data integrity
5. **Audit Fields**: `created_at` and `updated_at` timestamps on all tables
6. **Triggers**: Automatic timestamp updates
7. **Comments**: Table and column documentation using PostgreSQL comments
8. **Cascade Operations**: Proper CASCADE settings on foreign keys
9. **Data Types**: Appropriate PostgreSQL data types for each field
10. **Naming Conventions**: Consistent snake_case naming

## Schema Diagram

```
┌─────────────┐
│   items     │
├─────────────┤
│ item_id (PK)│
│ name        │
│ price       │
│ description │
│ category    │
│ brand       │
│ sku         │
└──────┬──────┘
       │
       │ 1:N
       │
┌──────▼──────┐
│   stock     │
├─────────────┤
│ id (PK)     │
│ item_id (FK)│
│ in_stock    │
│ quantity    │
│ warehouse   │
└─────────────┘

┌──────────────────┐
│   tracking       │
├──────────────────┤
│ tracking_no (PK) │
│ status           │
│ current_location │
│ estimated_deliv. │
│ delivery_date    │
└────────┬─────────┘
         │
         │ 1:N
         │
┌────────▼─────────┐
│ tracking_events  │
├──────────────────┤
│ id (PK)          │
│ tracking_no (FK) │
│ timestamp        │
│ location         │
│ status           │
│ description      │
└──────────────────┘
```

## Notes

- The database owner is set to `postgres` by default. Modify if needed.
- All timestamps use `TIMESTAMP WITH TIME ZONE` for proper timezone handling
- The scripts include commented-out DROP statements for easy recreation
- Foreign key constraints use CASCADE for DELETE and UPDATE operations
- The scripts assume PostgreSQL 12+ for certain features

## Troubleshooting

### Database already exists
If you see "database already exists" error, uncomment the DROP DATABASE line in `01_create_database.sql`.

### Tables already exist
Uncomment the DROP TABLE lines at the beginning of each table creation script.

### Permission denied
Ensure you're running the scripts with a user that has CREATE DATABASE and CREATE TABLE privileges.

### Function already exists
The `update_updated_at_column()` function is created in the items table script and reused by other scripts. If you run the scripts out of order or multiple times, you may see "function already exists" messages (which can be safely ignored).
