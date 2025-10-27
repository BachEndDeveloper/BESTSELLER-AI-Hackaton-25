package com.bestseller.api.controller;

import com.bestseller.api.model.StockInfo;
import com.bestseller.api.service.StockService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/v1/stock")
public class StockController {

    private final StockService stockService;

    public StockController(StockService stockService) {
        this.stockService = stockService;
    }

    @GetMapping(value = "/{itemId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Mono<StockInfo> getStockByItemId(@PathVariable String itemId) {
        return stockService.getStockByItemId(itemId);
    }
}
