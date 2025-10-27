namespace BestsellerApi.ApiService.Models;

public record StockInfo(
    string ItemId,
    bool InStock,
    int Quantity,
    string? Warehouse,
    DateTimeOffset? LastUpdated
);
