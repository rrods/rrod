module Rrod
  module Model
    module Schema

      def attributes
        @attributes ||= {}
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
        found(nil, value)
      end

    end
  end
end
