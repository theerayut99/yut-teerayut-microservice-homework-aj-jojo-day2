FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder

WORKDIR /src
COPY src/CSharpService.csproj ./
RUN dotnet restore ./CSharpService.csproj
COPY src/. ./
RUN dotnet publish ./CSharpService.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runner

WORKDIR /app
COPY --from=builder /app/publish .

EXPOSE 8080
ENTRYPOINT ["dotnet", "CSharpService.dll"]
