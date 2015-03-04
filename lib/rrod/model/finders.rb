module Rrod
  module Model
    module Finders

      def find(*ids)
        if ids.length == 1
          find_one(ids.first).tap { |found| raise NotFound.new if found.nil? }
        else
          find_many(ids) 
        end 
      end

      def find_one(id)
        robject = bucket.get(id) 
        found(id, robject.data, robject) 
      rescue Riak::FailedRequest => e 
        raise e unless e.not_found?
      end

      def find_by(query)
        find_by!(query) 
      rescue Rrod::Model::NotFound
        nil
      end
 
      def find_by!(query)
        return find(query[:id]) if query[:id]
        find_all_by!(query).first
      end
      
      def find_all_by(query)
        find_all_by!(query)
      rescue Rrod::Model::NotFound
        []   
      end

      def find_all_by!(attributes)
        query = Query.new(attributes)
        raise ArgumentError.new("Cannot search by id") if query.using_id?
        search(query).map{ |doc| found(nil, doc) } 
      end
        
      private 
  
      def search(query)
        records = client.search(bucket_name, query.to_s)['docs']
        raise NotFound.new unless records.any?
        records
      end

      def find_many(ids)  
        bucket.get_many(ids).map{|doc| found(doc.first, doc.last.data) }
      end

      def found(key, data, robject=nil)
        instantiate(key, data).tap { |instance|
          instance.robject = robject
          instance.instance_variable_set(:@persisted, true)
        }
      end

      # when searching documents do not come back with robjects,
      # we must set the key manually on it via `id=`
      def instantiate(key, data)
        new data.merge(id: key)
      end

    end

    NotFound = Class.new(StandardError)
  end
end
