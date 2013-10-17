module Rrod
  module Model
    module Attributes

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
        @attributes[key.to_s] = value
      end
      alias :[]= :write_attribute

      private

      def magic_methods=(keys)
        @magic_methods = keys.inject([]) { |acc, k| acc << k.to_s << "#{k}=" }
      end

      def define_singleton_getter(attribute)
        define_singleton_method attribute do
          read_attribute attribute
        end
      end

      def define_singleton_setter(attribute)
        define_singleton_method "#{attribute}=" do |value|
          write_attribute attribute, value
        end
      end

      def method_missing(method_id, *args, &block)
        method = method_id.to_s
        return super unless @magic_methods.include?(method)

        accessor = method.ends_with?('=') ? :setter : :getter
        send "define_singleton_#{accessor}", method.chomp('=')
        send method_id, *args
      end

      def respond_to_missing?(*args)
        @magic_methods.include? args.first.to_s
      end

    end
  end
end
