module Rrod
  module Model
    class Collection
      include Enumerable

      delegate(*%w[clear count each length size], to: :collection)

      def initialize(collection=[])
        self.collection = collection
      end

      def collection=(collection)
        raise InvalidCollectionTypeError.new unless collection.respond_to?(:each)
        collection.map { |member| push member }
      rescue InvalidMemberTypeError => e
        clear and raise e
      end

      def collection
        @collection ||= []
      end

      def push(value)
        raise InvalidMemberTypeError.new unless Rrod::Model === (value)
        collection.push(value)
      end
      alias :<< :push

      def serializable_hash(*)
        collection.map(&:serializable_hash)
      end

      InvalidCollectionTypeError = Class.new(StandardError)
      InvalidMemberTypeError     = Class.new(StandardError)
    end
  end
end
