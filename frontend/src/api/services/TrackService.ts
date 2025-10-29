/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { TrackingInfo } from '../models/TrackingInfo';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class TrackService {
    /**
     * Get tracking status
     * Returns the current status and tracking information for the provided tracking number
     * @returns TrackingInfo Successful response
     * @throws ApiError
     */
    public static getTrackingStatus({
        trackingNo,
    }: {
        /**
         * Tracking number for the shipment
         */
        trackingNo: string,
    }): CancelablePromise<TrackingInfo> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/track/{trackingNo}',
            path: {
                'trackingNo': trackingNo,
            },
            errors: {
                404: `Tracking number not found`,
                500: `Internal server error`,
            },
        });
    }
}
