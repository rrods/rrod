module Rrod
  module Model
    class Collection
      include Enumerable

      attr_accessor :collection
      delegate :each, :count, :size, :length, to: :collection

      def initialize(collection)
        self.collection = collection
      end

      def collection=(collection)
        raise InvalidCollectionTypeError.new unless Enumerable === collection
        raise InvalidMemberTypeError.new     unless collection.all? { |member| Rrod::Model === member }
        @collection = collection
      end

      def serializable_hash(*)
        collection.map(&:serializable_hash)
      end

      InvalidCollectionTypeError = Class.new(StandardError)
      InvalidMemberTypeError     = Class.new(StandardError)
    end
  end
end
