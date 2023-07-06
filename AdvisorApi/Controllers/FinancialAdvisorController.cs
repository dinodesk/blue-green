using AdvisorApi.Models;
using Microsoft.AspNetCore.Mvc;

namespace AdvisorApi.Controllers;

[ApiController]
[Route("[controller]")]
public class FinancialAdvisorController : ControllerBase
{
    private static readonly string[] KnownRepId = new[]
    {
        "N126", "N121", "3M03", "HM0093", "SX02"
    };

    private readonly ILogger<FinancialAdvisorController> _logger;

    public FinancialAdvisorController(ILogger<FinancialAdvisorController> logger)
    {
        _logger = logger;
    }

    [HttpGet()]
    public IEnumerable<string> Get()
    {
        return KnownRepId;
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Representative>> Get(string id)
    {
        if(KnownRepId.Contains(id))
        {
            await Task.Delay(1);
            var result = new Representative{ RepCode=id};
            return result;
        }
        return NotFound();
    }
}
