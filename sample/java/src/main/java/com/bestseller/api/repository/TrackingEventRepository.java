package com.bestseller.api.repository;

import com.bestseller.api.entity.TrackingEventEntity;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface TrackingEventRepository extends ReactiveCrudRepository<TrackingEventEntity, Integer> {

    @Query("SELECT * FROM tracking_events WHERE tracking_no = :trackingNo ORDER BY timestamp DESC")
    Flux<TrackingEventEntity> findByTrackingNoOrderByTimestampDesc(String trackingNo);
}
