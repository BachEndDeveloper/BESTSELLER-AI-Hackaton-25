using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BestsellerApi.ApiService.Entities;

[Table("tracking")]
public class Tracking
{
    [Key]
    [Column("tracking_no")]
    public string TrackingNo { get; set; } = string.Empty;

    [Required]
    [Column("status")]
    public string Status { get; set; } = string.Empty;

    [Required]
    [Column("current_location")]
    public string CurrentLocation { get; set; } = string.Empty;

    [Column("estimated_delivery")]
    public DateTimeOffset? EstimatedDelivery { get; set; }

    [Column("delivery_date")]
    public DateTimeOffset? DeliveryDate { get; set; }

    [Column("created_at")]
    public DateTimeOffset CreatedAt { get; set; }

    [Column("updated_at")]
    public DateTimeOffset UpdatedAt { get; set; }

    public ICollection<TrackingEventEntity> Events { get; set; } = new List<TrackingEventEntity>();
}
