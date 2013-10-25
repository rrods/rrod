module Rrod
  module Model
    module Serialization

      def to_json(options={})
        as_json.to_json
      end

      def as_json(options={})
        attributes.inject({}) { |hash, (key, value)|
          hash[key] = value.respond_to?(:as_json) ? value.as_json : value
          hash
        }
      end

    end
  end
end
