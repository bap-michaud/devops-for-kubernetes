/**
 * Shared configuration utilities for multi-repo services
 * Published as an npm package for consistent configuration management
 */

class Config {
  constructor() {
    this.env = process.env.NODE_ENV || 'development';
  }

  // Database configuration
  getDatabase() {
    return {
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT) || 5432,
      name: process.env.DB_NAME || 'devops_demo',
      ssl: this.env === 'production',
      pool: {
        min: parseInt(process.env.DB_POOL_MIN) || 2,
        max: parseInt(process.env.DB_POOL_MAX) || 10
      }
    };
  }

  // Redis configuration
  getRedis() {
    return {
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT) || 6379,
      password: process.env.REDIS_PASSWORD,
      db: parseInt(process.env.REDIS_DB) || 0
    };
  }

  // Security configuration
  getSecurity() {
    return {
      cors: {
        origin: process.env.CORS_ORIGIN || '*',
        credentials: true
      },
      rateLimit: {
        windowMs: 15 * 60 * 1000, // 15 minutes
        max: parseInt(process.env.RATE_LIMIT_MAX) || 100
      },
      jwt: {
        secret: process.env.JWT_SECRET || 'dev-secret',
        expiresIn: process.env.JWT_EXPIRES_IN || '24h'
      }
    };
  }

  // Health check configuration
  getHealthCheck() {
    return {
      timeout: parseInt(process.env.HEALTH_TIMEOUT) || 5000,
      interval: parseInt(process.env.HEALTH_INTERVAL) || 30000
    };
  }

  // Logging configuration
  getLogging() {
    return {
      level: process.env.LOG_LEVEL || 'info',
      format: process.env.LOG_FORMAT || 'json'
    };
  }
}

module.exports = Config;