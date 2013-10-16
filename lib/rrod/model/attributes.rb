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

      def attributes
        @attributes.keys.inject({}) { |acc, key|
          acc.tap { |hash| hash[key] = respond_to?(key) ? public_send(key) : nil }
        }
      end

      def attributes=(attrs)
        attrs.each do |key, value|
          public_send "#{key}=", value
        end
      end

      def read_attribute(key)
        @attributes[key.to_s]
      end
      alias :[] :read_attribute

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
