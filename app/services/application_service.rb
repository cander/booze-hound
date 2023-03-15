# Some syntactic sugar for service objects
# Usage: MyService.call(args)
class ApplicationService
  def self.call(...)
    new(...).call
  end

  @@logger = Rails.logger
  def logger
    @@logger
  end
end
