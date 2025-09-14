const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

// Middleware
app.use(express.json());

// Health check endpoints
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    service: 'multi-repo-api-service',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

app.get('/ready', (req, res) => {
  res.status(200).json({
    status: 'ready',
    service: 'multi-repo-api-service',
    timestamp: new Date().toISOString()
  });
});

// Metrics endpoint
app.get('/metrics', (req, res) => {
  res.set('Content-Type', 'text/plain');
  res.send(`
# HELP api_requests_total Total number of API requests
# TYPE api_requests_total counter
api_requests_total{method="GET",status="200"} ${Math.floor(Math.random() * 500)}

# HELP api_uptime_seconds API service uptime in seconds
# TYPE api_uptime_seconds gauge
api_uptime_seconds ${process.uptime()}
  `.trim());
});

// API endpoints
app.get('/api/v1/status', (req, res) => {
  res.json({
    service: 'multi-repo-api-service',
    version: '1.0.0',
    status: 'running',
    environment: process.env.NODE_ENV || 'development',
    repository: 'multi-repo/api-service'
  });
});

app.get('/api/v1/data', (req, res) => {
  // Mock data endpoint
  res.json({
    data: [
      { id: 1, name: 'Sample Data 1', value: 100 },
      { id: 2, name: 'Sample Data 2', value: 200 }
    ],
    total: 2,
    timestamp: new Date().toISOString()
  });
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
    process.exit(0);
  });
});

const server = app.listen(port, () => {
  console.log(`Multi-repo API service listening on port ${port}`);
});