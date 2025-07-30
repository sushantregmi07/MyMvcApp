# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Copy the .csproj file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application and build it
COPY . ./
RUN dotnet publish -c Release -o /out

# Define the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy the build output from the build stage
COPY --from=build /out .

# Expose the port the app will run on (use 80 for HTTP)
EXPOSE 80

# Start the application
ENTRYPOINT ["dotnet", "MyMvcApp.dll"]