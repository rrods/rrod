module Rrod
  module Model
    class Attribute
       
      attr_accessor :name, :type, :options

      # @param [Symbol] The name of the attribute
      # @param [Class] The type of the attribute for marshalling
      # @param [Hash] Options for the attribute (they are optional).
      def initialize(name, type, options={})
        self.name = name
        self.type = type
        self.options = options
      end

      def default
        options[:default].respond_to?(:call) ? options[:default].call : options[:default]
      end

      private

      def name=(value)
        @name = value.to_sym
      end

      def type=(value)
        @type = value
      end
    end
  end
end
