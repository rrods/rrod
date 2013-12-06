module Rrod
  class Caster
    module NestedModel

      def rrod_cast(values)
        return if values.nil?
        Rrod::Model::Collection.new(values.map { |value| model.rrod_cast(value) })
      end

      def model
        first
      end

    end
  end
end
