package com.bestseller.api.model;

import java.time.Instant;

public record TrackingEvent(
    Instant timestamp,
    String location,
    String status,
    String description
) {
}
