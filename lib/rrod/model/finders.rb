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

      def find_by(attributes)
        begin
          find_by!(attributes)
        rescue Rrod::Model::NotFound  
          nil
        end     
      end
 
      def find_by!(attributes)
        return find(attributes[:id]) if attributes[:id]
        find(find_by_index(retrieve_index(attributes)).first)
      end
      
      def search(attributes)
        search!(attributes)
      rescue Rrod::Model::NotFound
        []   
      end

      def search!(attributes)
        raise ArgumentError.new("Cannot search by id") if attributes[:id]  
        return multi_index_fetch(attributes) if attributes.length > 1 
        find_many(find_by_index(retrieve_index(attributes)))
      end
        
      private 
      
      def multi_index_fetch(attributes)
        mr = Riak::MapReduce.new(client)  
        attributes.to_a.each do |ind| 
          ind = retrieve_index(ind) 
          mr.index client[bucket_name], ind[:index_name], ind[:value] 
        end
        find_many(mr.run.collect{|res| res.last})
      end

      def retrieve_index(attributes)
        field,val = attributes.flatten
        index_list = indexes
        index_hash = Hash[*index_list.select{|ind| ind[:attribute_name] == field}]
        {index_name: "#{index_hash[:attribute_name]}_#{index_hash[:type]}", value: val}  
      end
      
      def find_by_index(opt)
        client[bucket_name].get_index opt[:index_name], opt[:value]
      rescue Riak::FailedRequest => e
        raise NotFound.new 
      end

      def find_many(ids)  
        client[bucket_name].get_many(ids).map{|doc| found(nil, doc.last.data) }
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
