package com.bestseller.api.controller;

import com.bestseller.api.model.ItemDetail;
import com.bestseller.api.model.ItemSummary;
import com.bestseller.api.service.ItemService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/v1/items")
public class ItemController {

    private final ItemService itemService;

    public ItemController(ItemService itemService) {
        this.itemService = itemService;
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public Flux<ItemSummary> getAllItems() {
        return itemService.getAllItems();
    }

    @GetMapping(value = "/{itemId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Mono<ItemDetail> getItemById(@PathVariable String itemId) {
        return itemService.getItemById(itemId);
    }
}
