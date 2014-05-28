module Rrod
  module Model
    module Schema

      attr_accessor :lookup_field

      def attributes
        @attributes ||= {}
      end
     
      def indexes
        attributes.values.map(&:index).compact  
      end
      
      def attribute(name, type, options={})
        attributes[name.to_sym] = Attribute.new(self, name, type, options).define
      end

      def cast_attribute(key, value)
        attribute = attributes[key.to_sym]
        attribute ? attribute.cast(value) : value
      end

      def nested_in(parent)
        define_method(parent) { @_parent }
      end

      def schema?
        attributes.any?
      end

      def rrod_cast(value)
        return       if value.nil?
        return value if value.is_a?(Rrod::Model)
        raise UncastableObjectError.new("#{value.inspect} cannot be rrod_cast") unless Hash === value
        instantiate(nil, value)
      end

    end           
    UncastableObjectError = Class.new(StandardError)
  end
end
