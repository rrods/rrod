module Rrod
  class Caster
    module NestedModel

      def rrod_cast(values, model)
        return if values.nil?
        Rrod::Model::Collection.new(model, model_class, values)
      end

      def model_class
        first
      end

    end
  end
end
