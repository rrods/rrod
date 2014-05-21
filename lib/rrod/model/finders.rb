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
        find(find_by_index(query).first)
      end
      
      def search(query)
        search!(query)
      rescue Rrod::Model::NotFound
        []   
      end

      def search!(query)
        raise ArgumentError.new("Cannot search by id") if query[:id]  
        return mapred_index_fetch(query) if query.length > 1 
        find_many(find_by_index(query))
      end
        
      private 
      
      def find_index(field)
        attr = attributes[field]
        raise ArgumentError.new unless attr && attr.index
        attr.index
      end

      def mapred_index_fetch(query)
        mr = Riak::MapReduce.new(client)  
        query.each do |qr|
          field, value = qr
          index = find_index(field)
          mr.index bucket, index.name, value 
        end
        find_many(mr.run.collect{|res| res.last})
      end

      def find_by_index(query)
        raise NotFound.new if query.blank?
        field, term = query.first
        index = find_index(field)
        bucket.get_index index.name, term
      rescue Riak::FailedRequest => e
        raise NotFound.new 
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

      def instantiate(key, data)
        new(data).tap { |instance| instance.id = key if key }
      end

    end

    NotFound = Class.new(StandardError)
  end
end
