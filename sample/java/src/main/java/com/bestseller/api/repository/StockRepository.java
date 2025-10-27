package com.bestseller.api.repository;

import com.bestseller.api.entity.Stock;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

@Repository
public interface StockRepository extends ReactiveCrudRepository<Stock, Integer> {

    @Query("SELECT * FROM stock WHERE item_id = :itemId LIMIT 1")
    Mono<Stock> findByItemId(String itemId);
}
