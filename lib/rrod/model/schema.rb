module Rrod
  module Model
    module Schema

      def attributes
        @attributes ||= {}
      end
     
      def attribute(name, type, options={})
        attributes[name.to_sym] = Attribute.new(self, name, type, options).define
      end

      def cast_attribute(key, value, instance)
        attribute = attributes[key.to_sym]
        attribute ? attribute.cast(value, instance) : value
      end

      def nested_in(parent)
        define_method(parent) { @_parent }
      end

      def schema?
        attributes.any?
      end

      def rrod_cast(value, parent=nil)
        return if value.nil?

        cast_model = case value
        when Rrod::Model
          value
        when Hash
          instantiate(nil, value)
        else
          raise UncastableObjectError.new("#{value.inspect} cannot be rrod_cast") unless Hash === value
        end

        cast_model.tap { |m| m._parent = parent }
      end

    end           
    UncastableObjectError = Class.new(StandardError)
  end
end
