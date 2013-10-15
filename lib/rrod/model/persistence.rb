module Rrod
  module Model
    module Persistence

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

      def persist
        bucket.enable_index! unless bucket.is_indexed?
        robject.raw_data = attributes.to_json
        robject.key = id unless id.nil?
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

