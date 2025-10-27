using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BestsellerApi.ApiService.Entities;

[Table("stock")]
public class Stock
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Required]
    [Column("item_id")]
    public string ItemId { get; set; } = string.Empty;

    [Required]
    [Column("in_stock")]
    public bool InStock { get; set; }

    [Required]
    [Column("quantity")]
    public int Quantity { get; set; }

    [Column("warehouse")]
    public string? Warehouse { get; set; }

    [Column("last_updated")]
    public DateTimeOffset? LastUpdated { get; set; }

    [Column("created_at")]
    public DateTimeOffset CreatedAt { get; set; }

    [Column("updated_at")]
    public DateTimeOffset UpdatedAt { get; set; }
}
