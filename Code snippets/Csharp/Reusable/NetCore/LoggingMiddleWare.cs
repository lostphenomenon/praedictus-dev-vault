
// USAGE::
// Startup.Cs register middleware
        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            app.UseMiddleware<UnhandledExceptionMiddleware>();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            // Register exception logging middleware -->
            app.UseMiddleware<LoginExceptionMiddleware>();
            app.UseMonitoringEndpoint();
            app.UseHttpsRedirection();
            app.UseAuthentication();
            app.UseSwagger();
            app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API"));
            app.UseMvc();
        }


// CODE::
    public sealed class LoginExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<LoginExceptionMiddleware> _logger;

        public LoginExceptionMiddleware(RequestDelegate next, ILogger<LoginExceptionMiddleware> logger)
        {
            _next = next ?? throw new ArgumentNullException(nameof(next));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (InvalidLoginException)
            {
                HandleException(context, StatusCodes.Status401Unauthorized, "User is unauthorized.");
            }
            catch (InactiveUserException)
            {
                HandleException(context, StatusCodes.Status403Forbidden, "User is inactive.");
            }
            catch (ExpiredPasswordException)
            {
                HandleException(context, StatusCodes.Status401Unauthorized, "Password expired.");
            }
        }

        private async void HandleException(HttpContext context, int statusCode, string message)
        {
            if (context.Response.HasStarted)
            {
                _logger.LogWarning("Response has started so status code won't be changed.");
            }
            else
            {
                context.Response.StatusCode = statusCode;
                context.Response.ContentType = "text/plain";
                context.Response.ContentLength = message.Length;
                await context.Response.WriteAsync(message);
            }

            _logger.LogError($"Login failed for user {context.User.Identity.Name} with following error: {message}.");
        }