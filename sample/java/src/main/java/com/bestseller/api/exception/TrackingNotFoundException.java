package com.bestseller.api.exception;

public class TrackingNotFoundException extends RuntimeException {

    public TrackingNotFoundException(String trackingNo) {
        super("Tracking number not found: " + trackingNo);
    }
}
