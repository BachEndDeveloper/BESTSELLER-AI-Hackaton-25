var builder = DistributedApplication.CreateBuilder(args);

var postgres = builder.AddPostgres("postgres")
    .WithPgAdmin()
    .AddDatabase("postgres", "ai-demo");

var apiService = builder.AddProject<Projects.BestsellerApi_ApiService>("apiservice")
    .WithReference(postgres);

builder.Build().Run();
