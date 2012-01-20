################################################################################################
##  Interface Module                                                                           #
################################################################################################
#
# Taken from a great example
# http://www.metabates.com/2011/02/07/building-interfaces-and-abstract-classes-in-ruby/
#
# Check out the site for a description of what is going on in here.
#
# The purpose is to create an interface which will require the user to complete
# all of the necessary code before determining his/her code is complete.
#
################################################################################################

module BuyingGuideInterface
  
  class InterfaceNotImplementedError < NoMethodError
  end
  
  def self.included(klass)
    klass.send(:include, BuyingGuideInterface::Methods)
    klass.send(:extend, BuyingGuideInterface::Methods)
    klass.send(:extend, BuyingGuideInterface::ClassMethods)
  end
  
  module Methods
    
    def api_not_implemented(klass, method_name = nil)
      if method_name.nil?
        caller.first.match(/in \`(.+)\'/)
        method_name = $1
      end
      raise BuyingGuideInterface::InterfaceNotImplementedError.new("#{klass.class.name} needs to implement '#{method_name}' for interface #{self.name}!")
    end
    
  end
  
  module ClassMethods
    
    def needs_implementation(name, *args)
      self.class_eval do
        define_method(name) do |*args|
          BuyingGuidePage.api_not_implemented(self, name)
        end
      end
    end
    
  end
  
end