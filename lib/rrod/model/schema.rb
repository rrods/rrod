module Rrod
  module Model
    module Schema
      extend ActiveSupport::Concern

      module ClassMethods
        def attributes
          @attributes ||= {}
        end

        def attribute(name, type, options={})
          attributes[name.to_sym] = Attribute.new(name, type, options)
        end

      end

    end
  end
end
