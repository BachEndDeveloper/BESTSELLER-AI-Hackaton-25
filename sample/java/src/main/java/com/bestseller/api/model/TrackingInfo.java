package com.bestseller.api.model;

import java.time.Instant;
import java.util.List;

public record TrackingInfo(
    String trackingNo,
    String status,
    String currentLocation,
    Instant estimatedDelivery,
    Instant deliveryDate,
    List<TrackingEvent> history
) {
}
