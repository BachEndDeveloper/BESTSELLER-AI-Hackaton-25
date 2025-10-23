-- Script to create the PostgreSQL database for AI Demo
-- This script creates a new database named 'ai-demo'

-- Drop database if exists (uncomment if you want to recreate)
-- DROP DATABASE IF EXISTS "ai-demo";

-- Create the database
CREATE DATABASE "ai-demo"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Connect to the database
\c "ai-demo"

-- Add comment to describe the database
COMMENT ON DATABASE "ai-demo" IS 'BESTSELLER AI Hackathon 2025 - Demo Database for Items, Stock, and Tracking';
