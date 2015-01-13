module Rrod
  class Caster

    def initialize(&casting)
      @casting = casting
    end

    def rrod_cast(value, model = nil)
      return if value.nil?
      @casting.(value, model)
    end
            
    module Boolean
      extend self
      def rrod_cast(value, model = nil)
        [nil, false, 'false', 0, '0'].include?(value) ? false : true
      end
    end

    BigDecimal = new { |value| ::BigDecimal.new(value.to_s) } 
    Date       = new { |value| value.to_date }
    DateTime   = new { |value| value.to_datetime }
    Float      = new { |value| value.to_f }
    Integer    = new { |value| value.to_i }
    Numeric    = new { |value| 
      float_value = value.to_f
      int_value   = value.to_i
      float_value == int_value ? int_value : float_value
    }
    String     = new { |value| value.to_s }
    Symbol     = new { |value| value.to_sym }
    Time       = new { |value| value.to_time }
  end
end
