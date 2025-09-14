# Multi-stage Dockerfile with security best practices

# Build stage
FROM node:18-alpine AS builder

# Create app directory
WORKDIR /app

# Create non-root user for build stage
RUN addgroup -g 1001 -S nodejs && \
    adduser -S apiuser -u 1001

# Copy package files first for better layer caching
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY src/ ./src/

# Change ownership to non-root user
RUN chown -R apiuser:nodejs /app
USER apiuser

# Production stage
FROM node:18-alpine AS production

# Install security updates and dumb-init
RUN apk update && apk upgrade && apk add --no-cache dumb-init

# Create app directory
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S apiuser -u 1001

# Copy built application from builder stage
COPY --from=builder --chown=apiuser:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=apiuser:nodejs /app/package*.json ./
COPY --from=builder --chown=apiuser:nodejs /app/src ./src

# Switch to non-root user
USER apiuser

# Expose port (non-privileged port)
EXPOSE 8080

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["node", "src/server.js"]