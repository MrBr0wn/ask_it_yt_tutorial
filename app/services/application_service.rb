# Base class for UserBulkService.
# Creates an instance of the class and calls it action method
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
