module Rrod
  module Model
    module Finders
      extend ActiveSupport::Concern

      module ClassMethods

        def find(id)
          robject = bucket.get(id)
          new(robject.data)
        end

        def find_first_by(attributes)
          query = attributes_to_search(attributes)
          search = client.search(bucket_name, query)
          docs = search['docs']
          # TODO ensure docs.first not nil
          new(docs.first)
        end

        def find_all_by(attributes)
          query = attributes_to_search(attributes)
          search = client.search(bucket_name, query)
          docs = search['docs']
          docs.map { |doc| new(doc) }
        end

        def attributes_to_search(attributes)
          attributes.map { |key, value| "#{key}:#{value}" }.join(" AND ")
        end
      end
    end
  end
end
