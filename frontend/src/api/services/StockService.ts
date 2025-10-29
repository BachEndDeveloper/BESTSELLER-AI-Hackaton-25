/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { StockInfo } from '../models/StockInfo';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class StockService {
    /**
     * Get stock information for an item
     * Returns stock availability information for a specific item, including whether it is in stock and the quantity available
     * @returns StockInfo Successful response
     * @throws ApiError
     */
    public static getStockByItemId({
        itemId,
    }: {
        /**
         * Unique identifier of the item to check stock for
         */
        itemId: string,
    }): CancelablePromise<StockInfo> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/stock/{itemId}',
            path: {
                'itemId': itemId,
            },
            errors: {
                404: `Item not found`,
                500: `Internal server error`,
            },
        });
    }
}
