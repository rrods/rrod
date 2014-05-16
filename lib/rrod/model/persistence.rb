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

      def persist
        bucket.enable_index!
        robject.raw_data = to_json
        robject.key = id unless id.nil?
        self.class.indexes.each{|ind| 
          index_value = send(ind[:attribute_name]).send(ind[:type] == "int" ? :to_i : :to_s)
          robject.indexes["#{ind[:attribute_name]}_#{ind[:type]}"] << index_value
        }
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

