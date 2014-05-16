module Rrod
  module Model
    class Index
   
      attr_accessor :name, :type
   
      def initialize(name,type)
        @type = type == String ? "bin" : "int"
        @name = name 
      end

      def to_index_string
        "#{@name}_#{@type}"
      end   

    end

  end
end
