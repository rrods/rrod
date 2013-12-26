module Rrod
  module Model
    module AttributeMethods

      attr_accessor :_parent

      def initialize(attributes = {})
        @attributes        = {}
        self.magic_methods = attributes.keys
        self.attributes    = attributes
      end

      def id
        read_attribute :id
      end

      def id=(value)
        write_attribute :id, value
      end

      # Returns a new hash with all of the object's attributes.
      # @return [Hash] the object's attributes
      def attributes
        @attributes.keys.inject({}) { |acc, key|
          acc.tap { |hash| hash[key] = respond_to?(key) ? public_send(key) : nil }
        }
      end

      # Mass assign the attributes of the object.
      # @param [Hash] the attributes to mass assign
      def attributes=(attrs)
        attrs.each do |key, value|
          public_send "#{key}=", value
        end
      end

      # Read a single attribute of the object.
      # @param [Symbol, String] the key of the attribute to read
      # @return the attribute at the given key
      def read_attribute(key)
        @attributes[key.to_s]
      end
      alias :[] :read_attribute

      # Write a given value to the attributes for a given key.
      # @param [Symbol, String] the key of the attribute to write
      # @param the value to write to attributes
      def write_attribute(key, value)
        @attributes[key.to_s] = write_parent(self.class.cast_attribute(key, value))
      end
      alias :[]= :write_attribute

      private

      def write_parent(attribute)
        case attribute
        when Rrod::Model
          attribute._parent = self
        when Rrod::Model::Collection
          attribute.each { |attr| attr._parent = self }
        end
        attribute
      end

      def magic_methods=(keys)
        return if self.class.schema? # classes with attributes don't get magic methods
        @magic_methods = keys.inject([]) { |acc, k| acc << k.to_s << "#{k}=" }
      end

      def magic_methods
        @magic_methods || []
      end

      def define_singleton_reader(attribute)
        define_singleton_method attribute, Attribute.reader_definition(attribute)
      end

      def define_singleton_writer(attribute)
        define_singleton_method "#{attribute}=", Attribute.writer_definition(attribute)
      end

      def method_missing(method_id, *args, &block)
        method = method_id.to_s
        return super unless magic_methods.include?(method)

        accessor = method.ends_with?('=') ? :writer : :reader
        send "define_singleton_#{accessor}", method.chomp('=')
        send method_id, *args
      end

      def respond_to_missing?(*args)
        magic_methods.include? args.first.to_s
      end

    end
  end
end
