module Rrod
  module Model
    module Schema

      def attributes
        @attributes ||= {}
      end
     
      def indexes
        @indexes ||= []
      end

      def index(name,type = String) 
        # Todo: allow for 'index :foo, :bar'
        type = type == String ? "bin" : "int"
        indexes << {attribute_name:name, type:type} unless indexes.detect{|i| i[:attribute_name] == name}  
      end
      
      def attribute(name, type, options={})
        if options[:index]
          options.delete(:index)
          index name, type
        end
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
