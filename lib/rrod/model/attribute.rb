module Rrod
  module Model
    class Attribute

      def self.reader_definition(name)
        -> { read_attribute name }
      end

      def self.writer_definition(name)
        ->(value) { write_attribute name, value }
      end
       
      attr_accessor :model, :name, :type, :options, :default, :index

      # @param [Class] The class that is declaring the attribute
      # @param [Symbol] The name of the attribute
      # @param [Class] The type of the attribute for marshalling
      # @param [Hash] Options for the attribute (they are optional).
      def initialize(model, name, type, options={})
        self.model   = model
        self.name    = name.to_sym
        self.type    = type
        self.default = options.delete(:default)
        self.options = options
        set_index if options.delete(:index)
      end

      # @return [Object] default value or result of call on default value
      def default(instance)
        @default.respond_to?(:call) ? instance.instance_exec(&@default) : @default
      end

      def define
        define_reader
        define_writer
        apply_validators
        self
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
        set_lookup_field if type.is_a? Hash
        @type.extend(Rrod::Caster::NestedModel) if nested_model?
      end

      def nested_model?
        return true if type.is_a?(Hash) && type.first.last && type.first.last.ancestors.include?(Rrod::Model)
        type.is_a?(Array) and type.first.ancestors.include?(Rrod::Model)
      end

      def define_reader
        model.send :define_method, name, self.class.reader_definition(name)
      end

      def define_writer
        model.send :define_method, "#{name}=", self.class.writer_definition(name)
      end
      
      def set_index
        @index = Index.new(self)
      end
      
      def set_lookup_field 
        type.first.last.lookup_field = type.first.first
      end
  
      def apply_validators
        model.validates name, options if options.present?
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
