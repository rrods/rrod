module Rrod
  module Model
    module Finders

      def find(id)
        find_one(id).tap { |found| raise NotFound.new if found.nil? }
      end

      def find_one(id)
        robject = bucket.get(id) 
        found(id, robject.data, robject) 
      rescue Riak::FailedRequest => e 
        raise e unless e.not_found?
      end

      def find_first_by(attributes)
        query = Query.new(attributes)

        if query.using_id?
          find_one(query.id)
        else
          docs = search(query)
          docs.any? ? found(nil, docs.first) : nil
        end
      end

      def find_first_by!(attributes)
        find_first_by(attributes).tap { |model| raise NotFound.new if model.nil? }
      end

      def find_all_by(attributes)
        query = Query.new(attributes)
        raise ArgumentError.new('Cannot pass id to find_all_by') if query.using_id?
        search(query).map { |doc| found(nil, doc) }
      end

      def find_all_by!(attributes)
        find_all_by(attributes).tap { |models| raise NotFound.new if models.empty? }
      end

      private

      def search(query)
        client.search(bucket_name, query.to_s)['docs']
      end

      def found(key, data, robject=nil)
        new(data).tap { |instance| 
          instance.id      = key
          instance.robject = robject
          instance.instance_variable_set(:@persisted, true)
        }
      end

    end

    NotFound = Class.new(StandardError)
  end
end
