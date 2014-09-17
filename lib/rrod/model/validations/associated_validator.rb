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
          Array(associated_records).map(&:errors).reject(&:blank?).map(&:full_messages).map(&:to_sentence).flatten.join('; ')
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
