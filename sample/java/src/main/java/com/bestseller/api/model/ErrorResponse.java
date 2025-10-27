package com.bestseller.api.model;

public record ErrorResponse(
    Integer code,
    String message,
    String details
) {
}
