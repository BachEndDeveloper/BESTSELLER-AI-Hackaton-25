package com.bestseller.api.service;

import com.bestseller.api.entity.Stock;
import com.bestseller.api.exception.ItemNotFoundException;
import com.bestseller.api.model.StockInfo;
import com.bestseller.api.repository.StockRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class StockService {

    private static final Logger logger = LoggerFactory.getLogger(StockService.class);
    private final StockRepository stockRepository;

    public StockService(StockRepository stockRepository) {
        this.stockRepository = stockRepository;
    }

    public Mono<StockInfo> getStockByItemId(String itemId) {
        logger.debug("Fetching stock for item: {}", itemId);
        return stockRepository.findByItemId(itemId)
            .switchIfEmpty(Mono.error(new ItemNotFoundException(itemId)))
            .map(this::toStockInfo)
            .doOnSuccess(stock -> logger.info("Retrieved stock for item: {}", itemId))
            .doOnError(error -> logger.error("Error fetching stock for item: {}", itemId, error));
    }

    private StockInfo toStockInfo(Stock stock) {
        return new StockInfo(
            stock.itemId(),
            stock.inStock(),
            stock.quantity(),
            stock.warehouse(),
            stock.lastUpdated()
        );
    }
}
