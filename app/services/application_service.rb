# Some syntactic sugar for service objects
# Usage: MyService.call(args)
class ApplicationService
  def self.call(...)
    new(...).call
  end
end
