module Rrod
  module Model
    extend  ActiveSupport::Concern

    include Attributes
    include Persistence
    include Finders

    def self.client
      @client ||= Riak::Client.new(protocol: 'pbc')
    end

    module ClassMethods
      def client
        Rrod::Model.client
      end

      def bucket
        @bucket ||= client[bucket_name]
      end

      # TODO make class attribute
      def bucket_name
        name.tableize
      end
    end # ClassMethods

    def client
      self.class.client
    end

    def bucket
      self.class.bucket
    end
  end
end
