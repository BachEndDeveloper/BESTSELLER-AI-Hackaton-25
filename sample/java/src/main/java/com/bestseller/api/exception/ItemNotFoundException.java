package com.bestseller.api.exception;

public class ItemNotFoundException extends RuntimeException {

    public ItemNotFoundException(String itemId) {
        super("Item not found: " + itemId);
    }
}
