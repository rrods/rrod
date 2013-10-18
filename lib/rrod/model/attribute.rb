module Rrod
  module Model
    class Attribute

      def self.reader_definition(name)
        -> { read_attribute name }
      end

      def self.writer_definition(name)
        ->(value) { write_attribute name, value }
      end
       
      attr_accessor :model, :name, :type, :options

      # @param [Class] The class that is declaring the attribute
      # @param [Symbol] The name of the attribute
      # @param [Class] The type of the attribute for marshalling
      # @param [Hash] Options for the attribute (they are optional).
      def initialize(model, name, type, options={})
        self.model   = model
        self.name    = name
        self.type    = type
        self.options = options
      end

      # @return [Object] default value or result of call on default value
      def default
        options[:default].respond_to?(:call) ? options[:default].call : options[:default]
      end

      def define
        define_reader
        define_writer
      end

      def cast(value)
        caster = type.respond_to?(:rrod_cast) ? type : rrod_caster
        caster ? caster.rrod_cast(value) : value
      end

      private

      def name=(value)
        @name = value.to_sym
      end

      def type=(value)
        @type = value
      end

      def define_reader
        model.send :define_method, name, self.class.reader_definition(name)
      end

      def define_writer
        model.send :define_method, "#{name}=", self.class.writer_definition(name)
      end

      def rrod_caster
        "Rrod::Caster::#{type}".constantize
      rescue NameError
      end
    end
  end
end

# stand-in for true/false attribute types
Boolean = Module.new unless defined? ::Boolean