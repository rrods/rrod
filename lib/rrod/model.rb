module Rrod
  module Model
    extend  ActiveSupport::Concern

    include AttributeMethods
    include Persistence
    include Serialization

    include Validations

    include Callbacks
    include Timestamps

    module ClassMethods
      include Finders
      include Schema

      def client
        Rrod.configuration.client
      end

      def bucket
        @bucket ||= client[bucket_name]
      end

      def bucket_name
        (name.presence || Rrod::Model::Schema::ANONYMOUS).tableize
      end
    end

    def client
      self.class.client
    end

    def bucket
      self.class.bucket
    end

    def inspect
      %Q[#<#{inspect_name} attributes: #{inspect_attributes} object_id: #{object_id}>]
    end

    def inspect_name
      storage_name = nested_model? ?  "(nested)" : "[#{bucket.name}]"
      "#{self.class.name || self.class.to_s}#{storage_name}"
    end

    def inspect_attributes
      %Q[{#{attributes.map { |k, v| "#{k}: #{v.inspect}" }.join(', ')}}]
    end
  end
end
