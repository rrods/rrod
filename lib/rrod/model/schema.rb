module Rrod
  module Model
    module Schema
      extend ActiveSupport::Concern

      module ClassMethods
        def attributes
          @attributes ||= {}
        end

        def attribute(name, type, options={})
          name_id = name.to_sym
          attributes[name_id] = Attribute.new(self, name, type, options)
          attributes[name_id].define
        end
      end

    end
  end
end
