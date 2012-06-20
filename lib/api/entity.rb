# Add a convenience class method to Grape's Entity class
class Grape::Entity
	class << self
	  def expose_if_exists(attr)
	    expose attr, :if => Proc.new { |obj, opts| obj.respond_to?(attr) }
	  end
	end
end