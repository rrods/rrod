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

      # TODO make class attribute
      def bucket_name
        name.tableize
      end
    end

    def client
      self.class.client
    end

    def bucket
      self.class.bucket
    end
  end
end
