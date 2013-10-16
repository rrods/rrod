module Rrod
  module Model
    module Attributes

      def initialize(attributes = {})
        extend attribute_methods(attributes.stringify_keys)
        @attributes     = {}
        self.attributes = attributes
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

      def attribute_methods(attributes)
        attrs = attributes.tap { |a| a.delete('id') }

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

    end
  end
end
