module Rrod
  module Model
    module Serialization

      def self.included(base)
        base.send :include, ActiveModel::Serializers::JSON
        base.send :include, ActiveModel::Serializers::Xml
      end

      def read_attribute_for_serialization(key)
        value = read_attribute(key)
        value.respond_to?(:serializable_hash) ? value.serializable_hash : value
      end
     
      def to_json(options={})
        MultiJson.dump serializable_hash(options) 
      end

    end
  end
end
