namespace BestsellerApi.ApiService.Models;

public record TrackingEvent(
    DateTimeOffset Timestamp,
    string Location,
    string Status,
    string? Description
);
