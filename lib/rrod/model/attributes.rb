module Rrod
  module Model
    module Attributes

      attr_accessor :attributes, :id

      def initialize(attributes = {})
        self.attributes = attributes
        extend attribute_methods
      end

      def attribute_methods
        attrs = attributes.dup.tap { |a| a.delete(:id) }

        Module.new do
          attrs.keys.each do |key|
            define_method key do
              read_attribute key
            end

            define_method "#{key}=" do |value|
              write_attribute key, value
            end
          end
        end 
      end

      def read_attribute(key)
        attributes[key]
      end
      alias :[] :read_attribute

      def write_attribute(key, value)
        attributes[key] = value
      end
      alias :[]= :write_attribute
    end
  end
end
