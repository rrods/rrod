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
        find_by!(query) rescue nil
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
        return multi_index_fetch(query) if query.length > 1 
        find_many(find_by_index(query))
      end
        
      private 
      
      def multi_index_fetch(query)
        mr = Riak::MapReduce.new(client)  
        query.to_a.each do |q| 
          field, value = q.flatten.to_a
          attr = attributes[field] 
          raise ArgumentError.new("No index found for #{field}. Add 'index: true' to attribute definition") unless attr && attr.index 
          mr.index client[bucket_name], attr.index.name, value 
        end
        find_many(mr.run.collect{|res| res.last})
      end

      def find_by_index(query)
        raise NotFound.new if query.blank?
        field, term = query.flatten.to_a
        attr = attributes[field]
        raise NotFound.new unless attr && attr.index
        bucket.get_index attr.index.name, term
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
