module Rrod
  module Model
    class Attribute

      def self.reader_definition(name)
        -> { read_attribute name }
      end

      def self.writer_definition(name)
        ->(value) { write_attribute name, value }
      end

      def self.presence_definition(name)
        -> { self[name].present? }
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
        self.default = options.delete(:default) || nested_default
        self.options = options
        set_index if options.delete(:index)
      end

      def define
        define_attribute_method
        define_attribute
        define_reader
        define_writer
        define_presence
        define_default
        apply_validators
        self
      end

      def cast(value, instance)
        caster = type.respond_to?(:rrod_cast) ? type : rrod_caster
        caster ? caster.rrod_cast(value, instance) : value
      end

      private

      def name=(value)
        @name = value.to_sym
      end

      def type=(value)
        @type = value
        @type.extend(Rrod::Caster::NestedModel) if nested_model?
      end

      def nested_model?
        type.is_a?(Array) and type.first.ancestors.include?(Rrod::Model)
      end

      def nested_default
        return unless nested_model?
        model_class = type.model_class
        -> { Rrod::Model::Collection.new(self, model_class) }
      end

      def define_attribute_method
        model.define_attribute_method name
      end

      def define_attribute
        _self = self # i am a shadow of self
        model.define_singleton_method(
          "#{Rrod::Model::Schema::RROD_ATTRIBUTE_PREFIX}#{name}") { _self }
      end

      def define_reader
        model.send :define_method, name, self.class.reader_definition(name)
      end

      def define_writer
        model.send :define_method, "#{name}=", self.class.writer_definition(name)
      end

      def define_presence
        model.send :define_method, "#{name}?", self.class.presence_definition(name)
      end

      def define_default
        value  = default unless default.respond_to?(:call)
        method = default.respond_to?(:call) ? default : -> {value} 
        model.send :define_method, "#{name}_default", method
      end

      def set_index
        @index = Index.new(self)
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
