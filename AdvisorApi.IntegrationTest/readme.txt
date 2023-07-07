Incase dotnet project is not creating csproj extension.

dotnet new -i NUnit3.DotNetNew.Template
dotnet new nunit -n MyUnitTestProject

To clear all nuget cache

dotnet nuget locals all --clear

To add reference to project
dotnet add reference ../AdvisorApi/AdvisorApi.csproj 

Run project in docker and then integration test .