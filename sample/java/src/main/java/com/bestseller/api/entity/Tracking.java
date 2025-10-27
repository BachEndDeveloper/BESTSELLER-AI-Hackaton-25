package com.bestseller.api.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;

@Table("tracking")
public record Tracking(
    @Id
    @Column("tracking_no")
    String trackingNo,

    @Column("status")
    String status,

    @Column("current_location")
    String currentLocation,

    @Column("estimated_delivery")
    Instant estimatedDelivery,

    @Column("delivery_date")
    Instant deliveryDate,

    @Column("created_at")
    Instant createdAt,

    @Column("updated_at")
    Instant updatedAt
) {
}
