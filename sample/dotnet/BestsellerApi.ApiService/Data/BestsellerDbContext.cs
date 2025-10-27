using BestsellerApi.ApiService.Entities;
using Microsoft.EntityFrameworkCore;

namespace BestsellerApi.ApiService.Data;

public class BestsellerDbContext : DbContext
{
    public BestsellerDbContext(DbContextOptions<BestsellerDbContext> options) : base(options)
    {
    }

    public DbSet<Item> Items => Set<Item>();
    public DbSet<Stock> Stocks => Set<Stock>();
    public DbSet<Tracking> Trackings => Set<Tracking>();
    public DbSet<TrackingEventEntity> TrackingEvents => Set<TrackingEventEntity>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Item>(entity =>
        {
            entity.HasKey(e => e.ItemId);
            entity.Property(e => e.Price).HasPrecision(10, 2);
        });

        modelBuilder.Entity<Stock>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.ItemId);
        });

        modelBuilder.Entity<Tracking>(entity =>
        {
            entity.HasKey(e => e.TrackingNo);
            entity.HasMany(e => e.Events)
                .WithOne()
                .HasForeignKey(e => e.TrackingNo)
                .OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<TrackingEventEntity>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.TrackingNo);
        });
    }
}
