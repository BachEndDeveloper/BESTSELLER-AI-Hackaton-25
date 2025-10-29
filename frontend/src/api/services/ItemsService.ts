/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { ItemDetail } from '../models/ItemDetail';
import type { ItemSummary } from '../models/ItemSummary';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class ItemsService {
    /**
     * Get all items
     * Returns a list of all items with their name, item ID, and price
     * @returns ItemSummary Successful response
     * @throws ApiError
     */
    public static getAllItems(): CancelablePromise<Array<ItemSummary>> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/items',
            errors: {
                500: `Internal server error`,
            },
        });
    }
    /**
     * Get item by ID
     * Returns detailed information about a specific item including full description
     * @returns ItemDetail Successful response
     * @throws ApiError
     */
    public static getItemById({
        itemId,
    }: {
        /**
         * Unique identifier of the item
         */
        itemId: string,
    }): CancelablePromise<ItemDetail> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/items/{itemId}',
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
