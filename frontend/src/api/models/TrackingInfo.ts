/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { TrackingEvent } from './TrackingEvent';
export type TrackingInfo = {
    /**
     * Tracking number for the shipment
     */
    trackingNo: string;
    /**
     * Current status of the shipment
     */
    status: TrackingInfo.status;
    /**
     * Current location of the package
     */
    currentLocation: string;
    /**
     * Estimated delivery date and time
     */
    estimatedDelivery?: string;
    /**
     * Actual delivery date and time (only present when delivered)
     */
    deliveryDate?: string;
    /**
     * Historical tracking events
     */
    history?: Array<TrackingEvent>;
};
export namespace TrackingInfo {
    /**
     * Current status of the shipment
     */
    export enum status {
        PICKED_UP = 'Picked Up',
        PROCESSED = 'Processed',
        IN_TRANSIT = 'In Transit',
        OUT_FOR_DELIVERY = 'Out for Delivery',
        DELIVERED = 'Delivered',
        RETURNED = 'Returned',
        FAILED = 'Failed',
    }
}

