package com.bestseller.demo.plugin;

import com.bestseller.demo.data.DemoDataStore;
import com.bestseller.demo.model.TrackingInfo;
import com.microsoft.semantickernel.semanticfunctions.annotations.DefineKernelFunction;
import com.microsoft.semantickernel.semanticfunctions.annotations.KernelFunctionParameter;
import org.springframework.stereotype.Component;

/**
 * Semantic Kernel plugin for tracking information retrieval.
 * This plugin provides functions that can be called by the kernel to get shipment tracking details.
 */
@Component
public class TrackingPlugin {

    private final DemoDataStore dataStore;

    public TrackingPlugin(DemoDataStore dataStore) {
        this.dataStore = dataStore;
    }

    /**
     * Gets tracking information for a shipment.
     *
     * @param trackingNo the tracking number
     * @return tracking information as a formatted string
     */
    @DefineKernelFunction(
        name = "getTrackingInfo",
        description = "Retrieves tracking status and location information for a shipment"
    )
    public String getTrackingInfo(
        @KernelFunctionParameter(
            name = "trackingNo",
            description = "The tracking number for the shipment (e.g., 'TRK-2025-001')"
        ) String trackingNo
    ) {
        return dataStore.findTrackingByNumber(trackingNo)
            .map(tracking -> String.format(
                "Tracking Number: %s, Status: %s, Current Location: %s, Estimated Delivery: %s",
                tracking.trackingNo(),
                tracking.status(),
                tracking.currentLocation(),
                tracking.estimatedDelivery()
            ))
            .orElse("Tracking information not found for tracking number: " + trackingNo);
    }

    /**
     * Gets the delivery status for a shipment.
     *
     * @param trackingNo the tracking number
     * @return delivery status as a string
     */
    @DefineKernelFunction(
        name = "getDeliveryStatus",
        description = "Gets the current delivery status of a shipment"
    )
    public String getDeliveryStatus(
        @KernelFunctionParameter(
            name = "trackingNo",
            description = "The tracking number for the shipment (e.g., 'TRK-2025-001')"
        ) String trackingNo
    ) {
        return dataStore.findTrackingByNumber(trackingNo)
            .map(tracking -> {
                if (tracking.status().equalsIgnoreCase("Delivered")) {
                    return String.format("Your package has been delivered to: %s", tracking.currentLocation());
                } else {
                    return String.format("Your package is %s. Current location: %s. Expected delivery: %s",
                        tracking.status(),
                        tracking.currentLocation(),
                        tracking.estimatedDelivery()
                    );
                }
            })
            .orElse("Cannot get delivery status - tracking number not found: " + trackingNo);
    }
}
