module Rrod
  module Model
    module Schema

      RROD_ATTRIBUTE_PREFIX = "rrod_attribute_".freeze
      ANONYMOUS             = "anonymous".freeze

      def attributes
        @attributes ||= public_methods.map(&:to_s).reduce({}) { |acc, method|
          next acc unless method.starts_with?(RROD_ATTRIBUTE_PREFIX)
          key = method[RROD_ATTRIBUTE_PREFIX.length..-1]
          acc.tap { |hash| hash[key] = public_send(method) }
        }.with_indifferent_access
      end
     
      def attribute(name, type, options={})
        using_schema!
        Attribute.new(self, name, type, options).define
      end

      def cast_attribute(key, value, instance)
        method = "#{RROD_ATTRIBUTE_PREFIX}#{key}"
        if respond_to?(method)
          public_send(method).cast(value, instance)
        else
          value
        end
      end

      def nested_in(parent)
        define_method(parent) { _parent }
      end

      def using_schema!
        return if schema?
        instance_eval 'def schema?; true; end'
      end

      def schema?
        false
      end

      def rrod_cast(value, parent=nil)
        return if value.nil?

        cast_model = case value
        when Rrod::Model
          value
        when Hash
          new(value)
        else
          raise UncastableObjectError.new("#{value.inspect} cannot be rrod_cast") unless Hash === value
        end

        cast_model.tap { |m| m._parent = parent }
      end

    end           
    UncastableObjectError = Class.new(StandardError)
  end
end
