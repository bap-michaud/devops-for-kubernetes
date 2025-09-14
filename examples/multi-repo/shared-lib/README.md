# Shared Library

This is a shared utilities library for multi-repository Kubernetes DevOps services. It provides common functionality that can be reused across different services.

## Installation

```bash
npm install @devops-org/shared-lib
```

## Usage

```javascript
const { Logger, Config } = require('@devops-org/shared-lib');

// Initialize logger with service name
const logger = new Logger('my-service');
logger.info('Application started');

// Initialize configuration
const config = new Config();
const dbConfig = config.getDatabase();
```

## Components

### Logger

Structured JSON logging utility with different log levels:

```javascript
const logger = new Logger('service-name');

logger.info('Info message', { userId: 123 });
logger.warn('Warning message');
logger.error('Error message', { error: err.message });
logger.debug('Debug message'); // Only in development
```

### Config

Configuration management utility for common settings:

```javascript
const config = new Config();

// Database configuration
const db = config.getDatabase();
// Returns: { host, port, name, ssl, pool }

// Redis configuration  
const redis = config.getRedis();
// Returns: { host, port, password, db }

// Security settings
const security = config.getSecurity();
// Returns: { cors, rateLimit, jwt }

// Health check settings
const health = config.getHealthCheck();
// Returns: { timeout, interval }

// Logging settings
const logging = config.getLogging();
// Returns: { level, format }
```

## Environment Variables

The library uses these environment variables:

### Database
- `DB_HOST` - Database host (default: localhost)
- `DB_PORT` - Database port (default: 5432)
- `DB_NAME` - Database name (default: devops_demo)
- `DB_POOL_MIN` - Minimum pool connections (default: 2)
- `DB_POOL_MAX` - Maximum pool connections (default: 10)

### Redis
- `REDIS_HOST` - Redis host (default: localhost)
- `REDIS_PORT` - Redis port (default: 6379)
- `REDIS_PASSWORD` - Redis password
- `REDIS_DB` - Redis database number (default: 0)

### Security
- `CORS_ORIGIN` - CORS origin (default: *)
- `RATE_LIMIT_MAX` - Rate limit max requests (default: 100)
- `JWT_SECRET` - JWT secret key (default: dev-secret)
- `JWT_EXPIRES_IN` - JWT expiration (default: 24h)

### Logging
- `LOG_LEVEL` - Log level (default: info)
- `LOG_FORMAT` - Log format (default: json)

### Health Checks
- `HEALTH_TIMEOUT` - Health check timeout (default: 5000ms)
- `HEALTH_INTERVAL` - Health check interval (default: 30000ms)

## Development

```bash
# Install dependencies
npm install

# Run tests
npm test

# Run tests with coverage
npm run test:coverage

# Lint code
npm run lint
```

## Publishing

This library is published to GitHub Package Registry:

```bash
# Build and test
npm test

# Publish (runs prepublishOnly script)
npm publish
```

## Versioning

This library follows semantic versioning:
- **Major**: Breaking changes
- **Minor**: New features (backward compatible)
- **Patch**: Bug fixes (backward compatible)

## Multi-Repo Integration

Services consume this library as a dependency:

```json
{
  "dependencies": {
    "@devops-org/shared-lib": "^1.0.0"
  }
}
```

Updates are managed through standard npm dependency management, allowing services to upgrade independently while maintaining version compatibility.