/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
export type StockInfo = {
    /**
     * Unique identifier for the item
     */
    itemId: string;
    /**
     * Whether the item is currently in stock
     */
    inStock: boolean;
    /**
     * Number of units available in stock
     */
    quantity: number;
    /**
     * Name or location of the warehouse
     */
    warehouse?: string;
    /**
     * Timestamp when stock information was last updated
     */
    lastUpdated?: string;
};

