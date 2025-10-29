using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BestsellerApi.ApiService.Entities;

[Table("items")]
public class Item
{
    [Key]
    [Column("item_id")]
    public string ItemId { get; set; } = string.Empty;

    [Required]
    [Column("name")]
    public string Name { get; set; } = string.Empty;

    [Required]
    [Column("price")]
    public decimal Price { get; set; }

    [Required]
    [Column("description")]
    public string Description { get; set; } = string.Empty;

    [Column("category")]
    public string? Category { get; set; }

    [Column("brand")]
    public string? Brand { get; set; }

    [Column("sku")]
    public string? Sku { get; set; }

    [Column("created_at")]
    public DateTimeOffset CreatedAt { get; set; }

    [Column("updated_at")]
    public DateTimeOffset UpdatedAt { get; set; }
}
