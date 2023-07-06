# Use the .NET 6 SDK as the base image

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["AdvisorApi/AdvisorApi.csproj", "AdvisorApi/"]

RUN dotnet restore "AdvisorApi/AdvisorApi.csproj"
COPY . .
WORKDIR "/src/AdvisorApi"
RUN dotnet build "AdvisorApi.csproj"  -c Release -o /app/build

FROM build as publish
RUN dotnet publish "AdvisorApi.csproj"  -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AdvisorApi.dll"]
