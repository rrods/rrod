module Rrod
  class Caster
    module NestedModel

      def rrod_cast(values)
        return if values.nil?
        Rrod::Model::Collection.new(model, values)
      end

      def model
        first
      end

    end
  end
end
