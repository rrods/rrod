module Rrod
  module Model
    module Timestamps
      extend ActiveSupport::Concern

      module ClassMethods
        def timestamps!
          attribute :created_at, Time, default: -> { Time.now }
          attribute :updated_at, Time, default: -> { Time.now }
          before_save :touch
        end
      end

      def touch
        tap { self.updated_at = Time.now }
      end
    end
  end
end
