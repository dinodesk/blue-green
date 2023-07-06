using Dapper;
using MySqlConnector;

public class FinancialAdvisorService{
    private string _connectionString = "serverus-east-2.rds.amazonaws.com;database=mysql;user=admin;password=xxxx";
    public FinancialAdvisorService(){

    }

  public async Task<string> HealthCheck() {
    try{
using (MySqlConnection conn = new MySqlConnection(_connectionString))
        {
            var users = await conn.QueryAsync<string>("SELECT VERSION()");
            foreach (var user in users)
            {
                Console.WriteLine($"SqLVersion ={user}");
                return user;
            }
            return $"No SQL server {_connectionString} found or not connected.";
        }
    }
    catch(Exception ex)
    {
        Console.WriteLine("Error occured", ex);

    }
        return "Some Erro with mysql";
    }   
}