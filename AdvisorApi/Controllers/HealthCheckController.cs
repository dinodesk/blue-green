using Microsoft.AspNetCore.Mvc;

namespace AdvisorApi.Controllers;

[ApiController]
[Route("[controller]")]
public class HealthCheckController : ControllerBase{
private readonly ILogger<HealthCheckController> _logger;
    public HealthCheckController(ILogger<HealthCheckController> logger)
    {
        _logger = logger;
    }
  [HttpGet()]
    public async Task<string> Get()
    {
        var svc = new FinancialAdvisorService();
        var ver = await svc.HealthCheck();
        return $"MYSQL version {ver} is {DateTime.Now.ToLongDateString()}" ;
    }
}