module Rrod
  class Caster
    module NestedModel

      def rrod_cast(values)
        return if values.nil?
        Rrod::Model::Collection.new(model, values)
      end

      def model
        self.is_a?(Hash) ? self.first.last : first
      end

    end
  end
end
