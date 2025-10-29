using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BestsellerApi.ApiService.Entities;

[Table("tracking_events")]
public class TrackingEventEntity
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Required]
    [Column("tracking_no")]
    public string TrackingNo { get; set; } = string.Empty;

    [Required]
    [Column("timestamp")]
    public DateTimeOffset Timestamp { get; set; }

    [Required]
    [Column("location")]
    public string Location { get; set; } = string.Empty;

    [Required]
    [Column("status")]
    public string Status { get; set; } = string.Empty;

    [Column("description")]
    public string? Description { get; set; }

    [Column("created_at")]
    public DateTimeOffset CreatedAt { get; set; }
}
