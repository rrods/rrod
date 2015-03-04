module Rrod
  module Model
    module AttributeMethods
      extend ActiveSupport::Concern
      include ActiveModel::Dirty

      attr_accessor :_parent

      included do
        define_attribute_method :id
      end

      def initialize(attributes = {})
        @attributes        = {}.with_indifferent_access
        self.magic_methods = attributes.keys
        self.attributes    = attributes
        changes_applied
      end

      def id
        robject.key
      end

      def id=(value)
        id_will_change! unless id == value
        robject.key = value
      end

      # Returns a new hash with all of the object's attributes.
      # @return [Hash] the object's attributes
      def attributes
        self.class.attributes.keys.inject({}) { |acc, key|
          acc.tap { |hash| 
            next hash unless self.class.attributes.keys.include?(key.to_s)
            hash[key] = public_send(key)
          }
        }.tap { |hash| hash['id'] = id unless nested_model? }
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
        @attributes[key] || read_default(key)
      end
      alias :[] :read_attribute

      # Write a given value to the attributes for a given key.
      # @param [Symbol, String] the key of the attribute to write
      # @param the value to write to attributes
      def write_attribute(key, value)
        send("#{key}_will_change!") if changing_attribute?(key, value)
        @attributes[key] = cast_attribute(key, value)
      end
      alias :[]= :write_attribute

      def cast_attribute(key, value)
        self.class.cast_attribute(key, value, self)
      end

      def changing_attribute?(key, value)
        @attributes[key] != cast_attribute(key, value)
      end

      def read_default(key)
        method = "#{key}_default"
        return unless respond_to?(method)
        @attributes[key] = cast_attribute(key, send(method))
      end

      def nested_model?
        _parent.present?
      end

      private

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
