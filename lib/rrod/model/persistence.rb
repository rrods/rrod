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
        persist
      end

      def update(attributes)
        self.attributes = attributes
        save
      end
      alias :update_attributes :update
 
      def indexes
        self.class.indexes.inject({}) do |acc, index|
          acc.tap { |hash| hash[index.name] = [index.cast(self)] }
        end
      end

      def persist
        bucket.enable_index!
        robject.raw_data = to_json
        robject.key = id unless id.nil?
        robject.indexes.merge!(indexes)
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

