package com.bestseller.demo.model;

/**
 * Represents tracking information for a shipment.
 */
public record TrackingInfo(
    String trackingNo,
    String status,
    String currentLocation,
    String estimatedDelivery
) {}
