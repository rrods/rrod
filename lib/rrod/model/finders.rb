module Rrod
  module Model
    module Finders

      def find(id)
        robject = bucket.get(id)
        raise NotFoundError.new if robject.nil?
        found(robject.data, robject)
      end

      def find_first_by(attributes)
        docs = search(attributes)
        return if docs.blank?
        found(docs.first)
      end

      def find_first_by!(attributes)
        find_first_by(attributes).tap { |model|
          raise NotFoundError.new if model.nil?
        }
      end

      def find_all_by(attributes)
        docs = search(attributes) || []
        docs.map { |doc| found(doc) }
      end

      def find_all_by!(attributes)
        find_all_by(attributes).tap { |models|
          raise NotFoundError.new if models.empty?
        }
      end

      private

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

    NotFoundError = Class.new(StandardError)
  end
end
