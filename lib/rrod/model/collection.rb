module Rrod
  module Model
    class Collection
      include Enumerable
      attr_accessor :model

      # explicitly declare the public interface to the underlying collection
      COLLECTION_INTERFACE = %w[clear count each length size [] first last]

      delegate(*COLLECTION_INTERFACE, to: :collection)

      def initialize(model, collection=[])
        self.model      = model
        self.collection = collection
      end

      def _parent=(value)
        each { |member| member._parent = value }
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

      def build(attributes={})
        push attributes
      end

      def push(value)
        instance = model.rrod_cast(value)
        raise InvalidMemberTypeError.new unless model === instance
        collection.push(instance)
      end
      alias :<< :push

      def serializable_hash(*)
        collection.map(&:serializable_hash)
      end
      
      def valid?
        collection.all?{|c| c.valid? }
      end

      InvalidCollectionTypeError = Class.new(StandardError)
      InvalidMemberTypeError     = Class.new(StandardError)
    end
  end
end
