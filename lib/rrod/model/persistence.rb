module Rrod
  module Model
    module Persistence
      extend ActiveSupport::Concern # so we can override save

      attr_accessor :robject

      def persisted?
        @persisted
      end

      def new?
        !persisted?
      end
      alias :new_record? :new?

      def save
        persist.tap { changes_applied }
      end

      def update(attributes)
        self.attributes = attributes
        save
      end
      alias :update_attributes :update
 
      def persist
        bucket.enable_index!
        robject.raw_data = to_json(except: :id)
        robject.store
        self.id = robject.key
        @persisted = true
      end

      def robject
        @robject ||= bucket.new
      end
    end
  end
end

