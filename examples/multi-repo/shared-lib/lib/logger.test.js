const Logger = require('./logger');

describe('Logger', () => {
  let logger;
  let consoleSpy;

  beforeEach(() => {
    logger = new Logger('test-service');
    consoleSpy = {
      log: jest.spyOn(console, 'log').mockImplementation(),
      warn: jest.spyOn(console, 'warn').mockImplementation(),
      error: jest.spyOn(console, 'error').mockImplementation(),
      debug: jest.spyOn(console, 'debug').mockImplementation()
    };
  });

  afterEach(() => {
    Object.values(consoleSpy).forEach(spy => spy.mockRestore());
  });

  describe('info', () => {
    it('should log info messages with correct format', () => {
      logger.info('Test message', { key: 'value' });
      
      expect(consoleSpy.log).toHaveBeenCalledTimes(1);
      const loggedMessage = JSON.parse(consoleSpy.log.mock.calls[0][0]);
      
      expect(loggedMessage.level).toBe('info');
      expect(loggedMessage.service).toBe('test-service');
      expect(loggedMessage.message).toBe('Test message');
      expect(loggedMessage.key).toBe('value');
      expect(loggedMessage.timestamp).toBeDefined();
    });
  });

  describe('warn', () => {
    it('should log warning messages', () => {
      logger.warn('Warning message');
      
      expect(consoleSpy.warn).toHaveBeenCalledTimes(1);
      const loggedMessage = JSON.parse(consoleSpy.warn.mock.calls[0][0]);
      
      expect(loggedMessage.level).toBe('warn');
      expect(loggedMessage.message).toBe('Warning message');
    });
  });

  describe('error', () => {
    it('should log error messages', () => {
      logger.error('Error message');
      
      expect(consoleSpy.error).toHaveBeenCalledTimes(1);
      const loggedMessage = JSON.parse(consoleSpy.error.mock.calls[0][0]);
      
      expect(loggedMessage.level).toBe('error');
      expect(loggedMessage.message).toBe('Error message');
    });
  });

  describe('debug', () => {
    it('should log debug messages in development', () => {
      process.env.NODE_ENV = 'development';
      logger.debug('Debug message');
      
      expect(consoleSpy.debug).toHaveBeenCalledTimes(1);
    });

    it('should not log debug messages in production', () => {
      process.env.NODE_ENV = 'production';
      logger.debug('Debug message');
      
      expect(consoleSpy.debug).not.toHaveBeenCalled();
    });
  });
});