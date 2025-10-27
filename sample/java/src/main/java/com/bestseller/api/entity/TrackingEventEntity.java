package com.bestseller.api.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;

@Table("tracking_events")
public record TrackingEventEntity(
    @Id
    @Column("id")
    Integer id,

    @Column("tracking_no")
    String trackingNo,

    @Column("timestamp")
    Instant timestamp,

    @Column("location")
    String location,

    @Column("status")
    String status,

    @Column("description")
    String description,

    @Column("created_at")
    Instant createdAt
) {
}
