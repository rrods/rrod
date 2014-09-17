module Rrod
  module Model
    module Validations
      
      class AssociatedValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return if Array(value).collect{ |r| r.nil? || r.valid? }.all?
          record.errors.add(attribute, error_message_for(attribute, value))
        end

        private
   
        def error_message_for(attribute, associated_records) 
          if associated_records.respond_to?(:each_with_index)
            associated_records.enum_for(:each_with_index).collect do |record, index|
              next unless record.errors.any?
              record.errors.full_messages.to_sentence
            end.compact.flatten.join('; ')
          else
            associated_records.errors.full_messages.to_sentence 
          end
        end

      end
     
      module ClassMethods 

        def validates_associated(*attrs)
          validates_with AssociatedValidator, _merge_attributes(attrs)
        end

      end

    end
  end
end
