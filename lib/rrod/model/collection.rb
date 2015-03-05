module Rrod
  module Model
    class Collection
      include Enumerable
      attr_accessor :parent, :model

      # explicitly declare the public interface to the underlying collection
      COLLECTION_INTERFACE = %w[clear count each length size [] first last empty?]

      delegate(*COLLECTION_INTERFACE, to: :collection)

      def initialize(parent, model, collection=[])
        self.parent     = parent
        self.model      = model
        self.collection = collection
      end

      def _parent=(value)
        each { |member| member._parent = value }
      end

      def collection=(collection)
        message = "Object type #{collection.class} does not respond to :each"
        raise InvalidCollectionTypeError.new(message) unless collection.respond_to?(:each)
        collection.map { |member| push member }
      rescue InvalidMemberTypeError => e
        clear and raise e
      end

      def collection
        @collection ||= []
      end

      def build(attributes={})
        push(attributes).last
      end

      def push(value)
        instance = model.rrod_cast(value, parent)
        raise InvalidMemberTypeError.new unless model === instance
        collection.push(instance)
      end
      alias :<< :push

      def serializable_hash(*)
        collection.map(&:serializable_hash)
      end
      
      def valid?
        collection.all?(&:valid?)
      end

      def inspect
        %Q[[#{map(&:inspect).join(', ')}]]
      end

      InvalidCollectionTypeError = Class.new(StandardError)
      InvalidMemberTypeError     = Class.new(StandardError)
    end
  end
end
