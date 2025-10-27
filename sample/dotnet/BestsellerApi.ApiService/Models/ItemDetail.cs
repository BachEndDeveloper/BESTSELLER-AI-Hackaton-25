namespace BestsellerApi.ApiService.Models;

public record ItemDetail(
    string ItemId,
    string Name,
    decimal Price,
    string Description,
    string? Category,
    string? Brand,
    string? Sku
);
