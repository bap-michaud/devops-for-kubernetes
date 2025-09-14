/**
 * Shared configuration for all applications
 */

module.exports = {
  // Environment configuration
  env: process.env.NODE_ENV || 'development',
  
  // Health check configuration
  healthCheck: {
    timeout: 5000,
    interval: 30000
  },
  
  // Logging configuration
  logging: {
    level: process.env.LOG_LEVEL || 'info',
    format: 'json'
  },
  
  // Security configuration
  security: {
    cors: {
      origin: process.env.CORS_ORIGIN || '*',
      credentials: true
    },
    rateLimit: {
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 100 // limit each IP to 100 requests per windowMs
    }
  },
  
  // Database configuration (example)
  database: {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    name: process.env.DB_NAME || 'devops_demo',
    ssl: process.env.NODE_ENV === 'production'
  }
};