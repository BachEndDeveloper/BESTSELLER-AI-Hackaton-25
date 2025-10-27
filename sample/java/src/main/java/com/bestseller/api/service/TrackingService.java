package com.bestseller.api.service;

import com.bestseller.api.entity.Tracking;
import com.bestseller.api.entity.TrackingEventEntity;
import com.bestseller.api.exception.TrackingNotFoundException;
import com.bestseller.api.model.TrackingEvent;
import com.bestseller.api.model.TrackingInfo;
import com.bestseller.api.repository.TrackingEventRepository;
import com.bestseller.api.repository.TrackingRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.List;

@Service
public class TrackingService {

    private static final Logger logger = LoggerFactory.getLogger(TrackingService.class);
    private final TrackingRepository trackingRepository;
    private final TrackingEventRepository trackingEventRepository;

    public TrackingService(TrackingRepository trackingRepository,
                          TrackingEventRepository trackingEventRepository) {
        this.trackingRepository = trackingRepository;
        this.trackingEventRepository = trackingEventRepository;
    }

    public Mono<TrackingInfo> getTrackingStatus(String trackingNo) {
        logger.debug("Fetching tracking info for: {}", trackingNo);

        Mono<Tracking> trackingMono = trackingRepository.findById(trackingNo)
            .switchIfEmpty(Mono.error(new TrackingNotFoundException(trackingNo)));

        Mono<List<TrackingEvent>> eventsMono = trackingEventRepository
            .findByTrackingNoOrderByTimestampDesc(trackingNo)
            .map(this::toTrackingEvent)
            .collectList();

        return Mono.zip(trackingMono, eventsMono)
            .map(tuple -> toTrackingInfo(tuple.getT1(), tuple.getT2()))
            .doOnSuccess(tracking -> logger.info("Retrieved tracking info for: {}", trackingNo))
            .doOnError(error -> logger.error("Error fetching tracking info for: {}", trackingNo, error));
    }

    private TrackingEvent toTrackingEvent(TrackingEventEntity entity) {
        return new TrackingEvent(
            entity.timestamp(),
            entity.location(),
            entity.status(),
            entity.description()
        );
    }

    private TrackingInfo toTrackingInfo(Tracking tracking, List<TrackingEvent> events) {
        return new TrackingInfo(
            tracking.trackingNo(),
            tracking.status(),
            tracking.currentLocation(),
            tracking.estimatedDelivery(),
            tracking.deliveryDate(),
            events
        );
    }
}
