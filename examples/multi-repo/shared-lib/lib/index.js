/**
 * Main entry point for the shared library
 * Exports all utilities for easy importing
 */

const Logger = require('./logger');
const Config = require('./config');

module.exports = {
  Logger,
  Config
};