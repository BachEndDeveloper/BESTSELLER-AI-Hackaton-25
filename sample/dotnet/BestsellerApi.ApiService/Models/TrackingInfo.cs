namespace BestsellerApi.ApiService.Models;

public record TrackingInfo(
    string TrackingNo,
    string Status,
    string CurrentLocation,
    DateTimeOffset? EstimatedDelivery,
    DateTimeOffset? DeliveryDate,
    IReadOnlyList<TrackingEvent>? History
);
