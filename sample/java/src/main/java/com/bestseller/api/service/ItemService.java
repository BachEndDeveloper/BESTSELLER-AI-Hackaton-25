package com.bestseller.api.service;

import com.bestseller.api.entity.Item;
import com.bestseller.api.exception.ItemNotFoundException;
import com.bestseller.api.model.ItemDetail;
import com.bestseller.api.model.ItemSummary;
import com.bestseller.api.repository.ItemRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
public class ItemService {

    private static final Logger logger = LoggerFactory.getLogger(ItemService.class);
    private final ItemRepository itemRepository;

    public ItemService(ItemRepository itemRepository) {
        this.itemRepository = itemRepository;
    }

    public Flux<ItemSummary> getAllItems() {
        logger.debug("Fetching all items");
        return itemRepository.findAll()
            .map(item -> new ItemSummary(item.itemId(), item.name(), item.price()))
            .doOnComplete(() -> logger.info("Successfully retrieved all items"));
    }

    public Mono<ItemDetail> getItemById(String itemId) {
        logger.debug("Fetching item with id: {}", itemId);
        return itemRepository.findById(itemId)
            .switchIfEmpty(Mono.error(new ItemNotFoundException(itemId)))
            .map(this::toItemDetail)
            .doOnSuccess(item -> logger.info("Retrieved item: {}", item.itemId()))
            .doOnError(error -> logger.error("Error fetching item: {}", itemId, error));
    }

    private ItemDetail toItemDetail(Item item) {
        return new ItemDetail(
            item.itemId(),
            item.name(),
            item.price(),
            item.description(),
            item.category(),
            item.brand(),
            item.sku()
        );
    }
}
