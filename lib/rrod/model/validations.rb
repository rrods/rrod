module Rrod
  module Model
    module Validations
      extend ActiveSupport::Concern
      
      included do
        include ActiveModel::Validations
      end

      def save(options={})
        options.fetch(:validate, true) ? (valid? and super()) : super()
      end
    end
  end
end
