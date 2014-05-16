module Rrod
  module Model
    module Schema

      def attributes
        @attributes ||= {}
      end
     
      def indexes
        @indexes ||= []
      end

      def index(name,type = String, *args) 
        fields = [name] 
        unless type.is_a? Class
          fields << type << args
          fields.flatten.each {|field| add_index_and_fetch_type(field) }
        else
          add_index(fields.first, type)
        end
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
       
      private
      
      # TODO: Use this to fetch the type 
      def add_index_and_fetch_type(field)
        add_index field, attributes[field].type
      end
      
      def add_index(name, type)
        type = type == String ? "bin" : "int"                                                                                                                
        unless indexes.detect{|index| index[:attribute_name] == name}
          indexes << {attribute_name: name, type: type}
        end
      end

    end

    UncastableObjectError = Class.new(StandardError)
  end
end
