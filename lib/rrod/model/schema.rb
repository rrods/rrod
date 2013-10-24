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

      def schema?
        attributes.any?
      end

    end
  end
end
