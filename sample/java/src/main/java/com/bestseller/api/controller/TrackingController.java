package com.bestseller.api.controller;

import com.bestseller.api.model.TrackingInfo;
import com.bestseller.api.service.TrackingService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/v1/track")
public class TrackingController {

    private final TrackingService trackingService;

    public TrackingController(TrackingService trackingService) {
        this.trackingService = trackingService;
    }

    @GetMapping(value = "/{trackingNo}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Mono<TrackingInfo> getTrackingStatus(@PathVariable String trackingNo) {
        return trackingService.getTrackingStatus(trackingNo);
    }
}
