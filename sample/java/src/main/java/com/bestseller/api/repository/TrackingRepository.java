package com.bestseller.api.repository;

import com.bestseller.api.entity.Tracking;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrackingRepository extends ReactiveCrudRepository<Tracking, String> {
}
