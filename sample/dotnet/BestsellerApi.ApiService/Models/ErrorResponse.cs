namespace BestsellerApi.ApiService.Models;

public record ErrorResponse(
    int Code,
    string Message,
    string? Details
);
