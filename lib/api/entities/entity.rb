# Add a convenience class method to Grape's Entity class
class Grape::Entity
  def self.expose_if_exists(attr)
    self.expose attr, :if => Proc.new { |obj, opts| obj.respond_to?(attr) }
  end
end