module Rrod
  class Caster
    module NestedModel

      def rrod_cast(values)
        return if values.nil?
        values.map do |value|
          model.rrod_cast(value)
        end
      end

      def model
        first
      end

    end
  end
end
