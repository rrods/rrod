module Rrod
  module Model
    module Finders

      def find(id)
        robject = bucket.get(id)
        found(robject.data, robject)
      end

      def find_first_by(attributes)
        docs = search(attributes)
        return if docs.blank?
        found(docs.first)
      end

      def find_all_by(attributes)
        docs = search(attributes) || []
        docs.map { |doc| found(doc) }
      end

      def attributes_to_search(attributes)
        attributes.map { |key, value| "#{key}:#{value}" }.join(" AND ")
      end

      def search(attributes)
        query = attributes_to_search(attributes)
        search = client.search(bucket_name, query)
        search['docs']
      end

      def found(data, robject=nil)
        new(data).tap { |instance| 
          instance.robject = robject
          instance.instance_variable_set(:@persisted, true)
        }
      end

    end
  end
end
