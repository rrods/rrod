module Rrod
  module Model
    module Persistence
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

      def persist
        bucket.enable_index!
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

