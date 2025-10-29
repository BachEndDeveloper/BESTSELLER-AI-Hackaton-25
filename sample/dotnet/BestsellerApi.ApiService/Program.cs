using BestsellerApi.ApiService.Data;
using BestsellerApi.ApiService.Entities;
using BestsellerApi.ApiService.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();

// Add database context
builder.AddNpgsqlDbContext<BestsellerDbContext>("postgres");

builder.Services.AddOpenApi();

var app = builder.Build();

app.MapDefaultEndpoints();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

// Items endpoints
app.MapGet("/v1/items", async (BestsellerDbContext db) =>
{
    var items = await db.Items
        .Select(i => new ItemSummary(i.ItemId, i.Name, i.Price))
        .ToListAsync();
    
    return Results.Ok(items);
})
.WithName("GetAllItems")
.WithTags("Items")
.Produces<List<ItemSummary>>();

app.MapGet("/v1/items/{itemId}", async (string itemId, BestsellerDbContext db) =>
{
    var item = await db.Items
        .Where(i => i.ItemId == itemId)
        .Select(i => new ItemDetail(
            i.ItemId,
            i.Name,
            i.Price,
            i.Description,
            i.Category,
            i.Brand,
            i.Sku
        ))
        .FirstOrDefaultAsync();

    if (item == null)
    {
        return Results.Problem(
            statusCode: StatusCodes.Status404NotFound,
            title: "Resource not found",
            detail: $"Item not found: {itemId}");
    }

    return Results.Ok(item);
})
.WithName("GetItemById")
.WithTags("Items")
.Produces<ItemDetail>()
.ProducesProblem(StatusCodes.Status404NotFound);

// Stock endpoints
app.MapGet("/v1/stock/{itemId}", async (string itemId, BestsellerDbContext db) =>
{
    var stock = await db.Stocks
        .Where(s => s.ItemId == itemId)
        .Select(s => new StockInfo(
            s.ItemId,
            s.InStock,
            s.Quantity,
            s.Warehouse,
            s.LastUpdated
        ))
        .FirstOrDefaultAsync();

    if (stock == null)
    {
        return Results.Problem(
            statusCode: StatusCodes.Status404NotFound,
            title: "Resource not found",
            detail: $"Stock information not found for item: {itemId}");
    }

    return Results.Ok(stock);
})
.WithName("GetStockByItemId")
.WithTags("Stock")
.Produces<StockInfo>()
.ProducesProblem(StatusCodes.Status404NotFound);

// Tracking endpoints
app.MapGet("/v1/track/{trackingNo}", async (string trackingNo, BestsellerDbContext db) =>
{
    var tracking = await db.Trackings
        .Include(t => t.Events)
        .FirstOrDefaultAsync(t => t.TrackingNo == trackingNo);

    if (tracking == null)
    {
        return Results.Problem(
            statusCode: StatusCodes.Status404NotFound,
            title: "Resource not found",
            detail: $"Tracking number not found: {trackingNo}");
    }

    var history = tracking.Events
        .OrderBy(e => e.Timestamp)
        .Select(e => new TrackingEvent(
            e.Timestamp,
            e.Location,
            e.Status,
            e.Description
        ))
        .ToList();

    var trackingInfo = new TrackingInfo(
        tracking.TrackingNo,
        tracking.Status,
        tracking.CurrentLocation,
        tracking.EstimatedDelivery,
        tracking.DeliveryDate,
        history
    );

    return Results.Ok(trackingInfo);
})
.WithName("GetTrackingStatus")
.WithTags("Track")
.Produces<TrackingInfo>()
.ProducesProblem(StatusCodes.Status404NotFound);

app.Run();
