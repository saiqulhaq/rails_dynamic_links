[X]Set up project repository on GitHub with MIT license.
[X]Initialize Ruby on Rails 7+ app
[X]Install gems: tailwindcss-rails, hotwire-rails.
[ ]Configure Devise for admin authentication.

Models
[ ]Create Admin model with Devise.
[ ]Create App model: belongs_to admin, fields for name, custom_domain, api_token.
[X]Create Link model: integrated with dynamic_links gem for URL shortening functionality.
[ ]Set up multi-tenancy: using dynamic_links gem Client model instead of Apartment.

Controllers & Routes
[ ]Admins controller for dashboard, apps management.
[ ]Apps controller: CRUD, token generation/revocation.
[X]Links controller: shorten, redirect, analytics provided by dynamic_links gem.
[X]API endpoints: POST /v1/shortLinks (with api_key), GET /:short_code.
[X]Rate limiting with rack-attack gem.

Views & UI
[ ]Sidebar navigation: Dashboard, Apps, Users, Settings.
[ ]Apps list table: name, domain, token, created, actions.
[ ]Per-app view: links table, shorten form, charts.
[X]Use Tailwind CSS for styling.
[X]Hotwire (Turbo, Stimulus) for dynamic updates.

Features
[X]Implement URL shortening logic: multiple strategies via dynamic_links gem.
[X]Redirection with 301/302.
[ ]Click tracking middleware.
[ ]Expiration cron job or callback.
[ ]Custom aliases validation.
[ ]Analytics: basic charts with chartkick gem.

Performance & Monitoring
[X]Integrate ElasticAPM for performance monitoring with toggle support.
[ ]Optimize database queries for high-traffic scenarios.
[ ]Add indexes for frequently accessed fields.

Security & Extras
[ ]HTTPS enforcement.
[ ]Token-based API auth.
[X]Documentation: README with setup, configuration options, and usage examples.
[ ]Tests: Minitest for models, controllers, API.

Deployment
[ ]Heroku/DigitalOcean setup guide.
[ ]Environment config for production.
[X]Dockerfile and docker-compose for local development.
[ ]GitHub Actions for CI: run tests, linting.