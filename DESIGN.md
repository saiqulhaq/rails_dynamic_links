## System Design for Rails Dynamic Links

**Purpose**: The app is intended for private service and is not meant to be directly accessible by end users. The deployment target is Kubernetes.

### Core Features

1. **Shortening URLs**: Store original link, shortened link, and `client_id`. The `client_id` is a reference to the Client table, which contains an `api_key` needed to shorten a URL using the REST API. The first Client row is a dummy record for public use.
2. **Redirecting Short URLs**
3. **Analytics**

### Performance Needs

- Shortening URL feature: Up to 60 requests per minute (RPM) during peak hours.
- Redirection feature: Up to 600 RPM during peak hours.

### Scalability

- **Web Server**: Horizontal auto-scaling based on CPU load and RPM.
- **DB Server**: Horizontal auto-scaling based on CPU load.
- **Redis Server**: Horizontal scaling.

### Security Concerns

- Input validation to prevent injections and other attacks.
- Rate limiting per client to prevent abuse, using Rack::Attack gem for API Key limits.
- Malicious content is out of scope as this is for private use.

### Architecture

- Monolithic architecture using Ruby on Rails v7.

### Database Design

- **High Priority**: Support for any DB supported by ActiveRecord (MySQL, MariaDB, PostgreSQL), with PostgreSQL as the first target.
- **Normal Priority**: MongoDB with initial configuration only; no plans for data migration to a new DB.
- **Low Priority**: Cassandra DB.
- Implement Hash Based Partitioning based on the `client_id` column.
- Cache DB: Redis

### Shortening Strategy

Supports two methods for URL shortening:
1. **By Algorithm**: Default method with options like MD5, SHA-256, CRC32, Base62, nanoid, and a counter-based approach using a Redis counter or MongoDB primary key.
2. **By KGS (Key Generation Service)**: Requires ActiveJob to seed available short links.
3. **Manual Entry**: Users can write custom shortened URL characters (max 16 characters).

_Notes_:
- Both methods support time expiration (default: 100 years). An ActiveJob worker deletes expired data nightly. The redirection controller sends a job to delete expired URLs before showing a 404 page.
- System can switch to KGS for performance optimization.

### Analytics Tracking

- Uses "HTTP 302 Redirect" to ensure all redirection requests reach the backend for analytics. This is crucial for functional requirements.

### API Design

- Provides RESTful APIs for creating, retrieving, and managing short URLs.

### Analytics and Monitoring

- Logging: Utilizes Rails' logging feature.
- Analytics: Implemented using the Ahoy gem.

### Compliance and Privacy

- Adheres to policies outlined by the Ahoy gem.

### Deployment Strategy

- **CI/CD**: Implemented using GitHub Actions.
