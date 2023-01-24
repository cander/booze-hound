# Some syntactic sugar for service objects
# Usage: MyService.call(args)
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
