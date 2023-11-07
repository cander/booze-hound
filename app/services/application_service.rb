# Some syntactic sugar for service objects
# Usage: MyService.call(args)
#
# Services can return values from call, and they can record error/status
# messages using the error_message functions

class ApplicationService
  def self.call(...)
    reset_error_message
    new(...).call
  end

  def self.error_message
    Thread.current[error_key]
  end

  def self.error_message=(msg)
    Thread.current[error_key] = msg
  end

  def self.reset_error_message
    self.error_message = nil
  end

  @@logger = Rails.logger
  def logger
    @@logger
  end

  private_class_method def self.error_key
    "#{name}_error_message"
  end
end
