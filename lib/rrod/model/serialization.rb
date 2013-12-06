module Rrod
  module Model
    module Serialization

      def read_attribute_for_serialization(key)
        value = read_attribute(key)
        value.respond_to?(:serializable_hash) ? value.serializable_hash : value
      end

    end
  end
end
