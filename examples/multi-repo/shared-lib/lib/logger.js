/**
 * Shared logging utility for multi-repo services
 * Published as an npm package for reuse across repositories
 */

class Logger {
  constructor(service = 'unknown') {
    this.service = service;
  }

  _formatMessage(level, message, meta = {}) {
    return JSON.stringify({
      timestamp: new Date().toISOString(),
      level,
      service: this.service,
      message,
      ...meta
    });
  }

  info(message, meta) {
    console.log(this._formatMessage('info', message, meta));
  }

  warn(message, meta) {
    console.warn(this._formatMessage('warn', message, meta));
  }

  error(message, meta) {
    console.error(this._formatMessage('error', message, meta));
  }

  debug(message, meta) {
    if (process.env.NODE_ENV === 'development') {
      console.debug(this._formatMessage('debug', message, meta));
    }
  }
}

module.exports = Logger;