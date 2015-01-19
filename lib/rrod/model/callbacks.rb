module Rrod
  module Model
    module Callbacks
      extend ActiveSupport::Concern

      included do
        extend ActiveModel::Callbacks
        define_model_callbacks :assignment, :validation, :save, :create, :update
      end

      def attributes=(*)
        run_callbacks(:assignment) { super }
      end

      def valid?
        run_callbacks(:validation) { super }
      end

      def save(*)
        run_callbacks(:create) if new?
        run_callbacks(:update) if persisted?
        run_callbacks(:save) { super }
      end
    end
  end
end
