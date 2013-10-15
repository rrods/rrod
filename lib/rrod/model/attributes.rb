module Rrod
  module Model
    module Attributes

      attr_accessor :attributes, :id

      def initialize(attributes = {})
        self.attributes = attributes
        extend attribute_methods
        mass_assign
      end

      def attribute_methods
        attrs = attributes.dup.tap { |a| a.delete(:id) }

        Module.new do
          attrs.keys.each do |key|

            define_method key do
              instance_variable_get "@#{key}"
            end

            define_method "#{key}=" do |value|
              instance_variable_set "@#{key}", value
            end
            
          end
        end 
      end

      def mass_assign
        attributes.each do |key, value|
          public_send("#{key}=", value)
        end
      end
    end
  end
end
