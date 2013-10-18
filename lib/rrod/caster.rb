module Rrod
  class Caster
    def self.caster(&block)
      new(block)
    end

    def initialize(casting)
      @casting = casting
    end

    def rrod_cast(value)
      return if value.nil?
      @casting.(value)
    end

            
    BigDecimal = caster { |value| ::BigDecimal.new(value.to_s) } 
    Date       = caster { |value| value.to_date }
    DateTime   = caster { |value| value.to_datetime }
    Float      = caster { |value| value.to_f }
    Integer    = caster { |value| value.to_i }
    Numeric    = caster { |value| 
      float_value = value.to_f
      int_value   = value.to_i
      float_value == int_value ? int_value : float_value
    }
    String     = caster { |value| value.to_s }
    Symbol     = caster { |value| value.to_sym }
    Time       = caster { |value| value.to_time }
  end
end
