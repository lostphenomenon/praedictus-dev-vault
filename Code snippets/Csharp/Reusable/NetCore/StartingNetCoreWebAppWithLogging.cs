using System;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;
using Serilog.Formatting.Json;

namespace NetCore.Generic.Api
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Log.Logger = new LoggerConfiguration()
                .MinimumLevel.Debug()
                .MinimumLevel.Override("Microsoft", LogEventLevel.Information)
                .Enrich.FromLogContext()
                .WriteTo.Console()
                .CreateLogger();

            try
            {
                Log.Information("Starting web host");
                CreateWebHostBuilder(args).Build().Run();
            }
            catch (Exception ex)
            {
                Log.Fatal(ex, "Host terminated unexpectedly");
            }
            finally
            {
                Log.CloseAndFlush();
            }
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((hostingContext, config) =>
                {
                    var env = hostingContext.HostingEnvironment;
                    config.AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                        .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true, reloadOnChange: true);
                    config.AddEnvironmentVariables();
                })
                .ConfigureLogging((hostingContext, logging) =>
                {
                    logging.ClearProviders();
                    logging.AddConfiguration(hostingContext.Configuration.GetSection("Logging"));
                    logging.AddConsole();
                    logging.AddDebug();
                })
                .UseSerilog((hostingContext, loggerConfiguration) =>
                {

                    var logLevel = hostingContext.Configuration.GetValue<LogLevel>("Logging:LogLevel");
                    var logFile = hostingContext.Configuration.GetValue<string>("Logging:LogFile");

                    loggerConfiguration
                        .Enrich.FromLogContext()
                        .WriteTo.RollingFile(
                            new JsonFormatter(),
                            $"{logFile}.json",
                            (LogEventLevel) logLevel)
                        .WriteTo.RollingFile(
                            restrictedToMinimumLevel: (LogEventLevel) logLevel,
                            pathFormat: logFile,
                            outputTemplate:
                            "{Timestamp:HH:mm:ss.f} [{Level}] {SourceContext:l} {Message:l}{NewLine:l}{Exception:l}");
                })
                .UseUrls("http://*:5005")
                .UseStartup<Startup>();
    }
}
