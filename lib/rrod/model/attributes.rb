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

      protected

      def magic_methods=(keys)
        @magic_methods = keys.inject([]) { |acc, k| acc << k.to_s << "#{k}=" }
      end

      private

      def method_missing(method, *args, &block)
        name = method.to_s
        if @magic_methods.include?(name)
          if name[-1] == '='
            define_singleton_method method do |value|
              write_attribute method[0..-2], value
            end
          else
            define_singleton_method method do
              read_attribute method
            end
          end

          public_send method, *args
        else
          super
        end
      end

      def respond_to_missing?(*args)
        @magic_methods.include? args.first.to_s
      end

      class MagicAttributes
        attr_reader :attributes

        def initialize(attributes)
          @attributes = attributes
        end

        def methods
          @methods ||= attributes.keys.map(&:to_s)
        end

        def respond_to?(method)
          methods.include? attribute_name(method)
        end

        def attribute_name(method)
          method[-1].eql?('=') ?  method[0..-2] : method
        end

        def respond(method, *args)
          attribute = attribute_name(method)
          model[attribute]
          if setter?
            model[attribute] = args.first
          else
            model[attribute]
          end

          true
        end
      end

    end
  end
end
