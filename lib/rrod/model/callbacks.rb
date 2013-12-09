module Rrod
  module Model
    module Callbacks
      extend ActiveSupport::Concern

      included do
        extend ActiveModel::Callbacks
        define_model_callbacks :validation, :save
      end

      def valid?
        run_callbacks(:validation) { super }
      end

      def save(*)
        run_callbacks(:save) { super }
      end
    end
  end
end
